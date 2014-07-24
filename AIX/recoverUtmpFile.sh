#!/usr/bin/ksh
################################################################################
# @author      Anderson Deluiz (Twitter: @AndDeluiz)                           #
# @name        recoverUtmpFile.sh                                              #
# @version     1.0                                                             #
# @date        July 24, 2014                                                   #
# @description Cean out entries in the /etc/utmp file that have no current     #
#              matching correct process in the process table.                  #
#              This MUST be run by the root user, either from the command line #
#              or from the root crontab entry.                                 #
#              Original version available from IBM website at                  #
#              https://www-304.ibm.com/support/docview.wss?uid=isg3T1000194    #
#              (last visited: 24 jul, 2014).                                   #
#                                                                              #
# @usage       recoverUtmpFile.sh                                              #
# @require     bos.acct fileset                                                #
################################################################################

#---------------------------        INCLUDE       -----------------------------#

#---------------------------     DEBUG OPTIONS    -----------------------------#
# uncomment line(s) to activate debug function
# set -x    # print a trace of simple commands and their arguments
# set -v    # print shell input lines as they are read
# set -n    # read commands but do not execute them

#---------------------------   GLOBAL VARIABLES   -----------------------------#
vMyName=$(basename $0)
vOSName=$(uname -s)

vFwtmpCmd=/usr/sbin/acct/fwtmp
vUtmpFilePath=/etc/utmp

#---------------------------       FUNCTIONS      -----------------------------#

#------------------------------------------------------------------------------#
# @function    usage                                                           #
# @description Displays usage of this script and help messages and exit script.#
#                                                                              #
# @usage       usage                                                           #
# @in          none                                                            #
# @return      none                                                            #
# @return-code                                                                 #
#              none                                                            #
# @exit-code                                                                   #
#              255 - normal exit code                                          #
#------------------------------------------------------------------------------#
usage()
{
   :
   exit 255
}

#---------------------------     MAIN SECTION     -----------------------------#
if [ ! -s ${vFwtmpCmd} ]
then
# accounting fileset (bos.acct) not installed
   print "Accounting (bos.acct fileset) must be installed first, fwtmp command does not exist"
   exit
fi

vSum=1
vNewSum=0

while [ "${vSum}" != "${vNewSum}" ]
do
  vSum=$(/usr/bin/sum ${vUtmpFilePath})
  ${vFwtmpCmd} < ${vUtmpFilePath} > /tmp/utmp.out
  ps au | awk '{print $2,$1,$7}' | grep -v USER > /tmp/ps.out
  vNewSum=$(/usr/bin/sum ${vUtmpFilePath})
  
  # loop until the file is unchanged
  # on a busy system, this may take a long time.
done

cat /tmp/utmp.out | awk '
  # load the array
  BEGIN
  {
    counter=0
    holder = ""
    ss=1
    while (ss == 1)
    {
      ss = (getline holder < "/tmp/ps.out")
      if (ss == 0)
        break
      n=split(holder,temp)
      combine=sprintf("%s %s",temp[2],temp[3])
      lookup[temp[1]]=combine
    }
  } # end of BEGIN section
  # AWK main section
  {
    if ((length($4) == 1) && ($4 == 7))
    {
      ps_name=lookup[$5]
      if (length(ps_name)  > 0)
      {
        # found a ps table entry with same pid
        # entry needs to be checked for accuracy
        # only if the name and tty match, write the entry
        utmp_name=sprintf("%s %s",$1,$2)
        if (ps_name == utmp_name)
          print $0
      }
    }
    else # Not an entry to look at, just pass it along
    {
      print $0
    }
  }' > /tmp/utmp.tmp

${vFwtmpCmd} -ic < /tmp/utmp.tmp  > /tmp/utmp.new

# Only if the /etc/utmp file is still unchanged from when
# we last looked will the file be overwritten with the
# updated copy.
#           WARNING WARNING WARNING
# There is a chance that this step may corrupt the
# /etc/utmp file if a process changes it after we look
# and before we can write it.
vCurrentSum=$(/usr/bin/sum ${vUtmpFilePath})
if [ "${vCurrentSum}" = "${vSum}" ]
then
  /usr/bin/cp /tmp/utmp.new /etc/utmp
  print "utmp file successfully updated on $(date)"
else
  print "utmp file was too busy on $(date) to update now"
  print "Try again later!"
fi

# clean temporary files
rm /tmp/ps.out
rm /tmp/utmp.out
rm /tmp/utmp.tmp
rm /tmp/utmp.new

exit 0
