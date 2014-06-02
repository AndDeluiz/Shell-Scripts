#!/usr/bin/ksh
################################################################################
# @author      Anderson Deluiz (Twitter: @AndDeluiz)                           #
# @name        createFilesystem.sh                                             #
# @version     0.9                                                             #
# @date        June 2nd, 2014                                                  #
# @description Displays commands for creating filesystems based on an input    #
#              pre-formatted CSV file.                                         #
#              Script based on scriptfs shell script written by Brian Smith    #
#              (twitter: @brian_smi) available at:                             #
#                 https://www.ibm.com/developerworks/community/blogs/brian/    #
#                                                                              #
# @usage       createFilesystem.sh                                             #
################################################################################

#---------------------------     DEBUG OPTIONS    -----------------------------#
# set -x
# set -v
# set -n
#------------------------------------------------------------------------------#

#---------------------------   GLOBAL VARIABLES   -----------------------------#
vOSName=$(uname -s)
#------------------------------------------------------------------------------#


#---------------------------       FUNCTIONS      -----------------------------#
usage()
{
   :
   exit 255
}

#---------------------------     MAIN SECTION     -----------------------------#
if [ $vOSName != 'AIX' ]
then
   usage
fi

if ! [ -r "$1" ]
then
   echo "Specify name of input CSV file on command line"
   exit 1
fi

cat "$1" | grep ^/ | while read line; do
        mount="`echo $line | awk -F, '{print $1}'"
        lv="`echo $line | awk -F, '{print $2}'"
        size="`echo $line | awk -F, '{print $3}'"
        vg="`echo $line | awk -F, '{print $4}'"
        user="`echo $line | awk -F, '{print $5}'"
        group="`echo $line | awk -F, '{print $6}'"
        perm="`echo $line | awk -F, '{print $7}'"
        options="`echo $line | awk -F, '{print $8}'"
        log="`echo $line | awk -F, '{print $9}'"

        echo "( mkdir -p $mount &&"
        echo "mklv -y $lv -t jfs2 -L $lv $vg ${size}G &&"
        myoptions=""
        mylog=""
        ! [ -z "$options" ] && myoptions="-a options=`echo $options | tr '.' ',' | tr -d ' '`"
        ! [ -z "$log" ] && mylog="-a logname=$log"
        echo "crfs -v jfs2 -d $lv -m $mount -A yes -p rw $myoptions $mylog &&"
        echo "mount $mount &&"
        echo "chown ${user}:${group} $mount &&"
        echo "chmod $perm $mount ) &&"
        echo "echo \"$mount created successfully\" ||"
        echo "echo \"ERROR creating $mount\""
        echo "echo"
        echo
done
