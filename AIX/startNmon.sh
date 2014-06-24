#!/usr/bin/ksh
################################################################################
# @author      Anderson Deluiz (Twitter: @AndDeluiz)                           #
# @name        startNmon.sh                                                    #
# @version     1.0                                                             #
# @date        June 24, 2014                                                   #
# @description This script starts nmon application in data collection mode.    #
#                                                                              #
# @usage       startNmon.sh                                                    #
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
   echo "${vMyName}: Starts nmon application in recording (data collection) mode."
   echo
   echo "Usage: ${vMyName} [-h]"
   echo "   -h   Displays this message and exit"
   echo
   echo "Before starting nmon, this script calculates how many snapshots will be taken until midnight."
   echo "Then nmon will be started with the following command:"
   echo "   # nmon -ftdMAV^ -s 900 -c <snapshots> -m /var/log/nmon"
   echo
   exit 255
}

#------------------------------------------------------------------------------#
# @function    parse                                                           #
# @description Parses command line options passed to this script               #
#                                                                              #
# @usage       parse <param>                                                   #
# @in          param - parameters to be parsed                                 #
# @return      none                                                            #
# @return-code                                                                 #
#              none                                                            #
# @exit-code                                                                   #
#              none                                                            #
#------------------------------------------------------------------------------#
parse()
{
   while getopts h vCmdArg
   do
      case ${vCmdArg} in
         'h')
            usage
            ;;
         '?')
            echo "ERROR: -${vCmdArg} Invalid option"
            usage
            ;;

      esac
   done
}

#------------------------------------------------------------------------------#
# @function    startNmon                                                       #
# @description Starts nmon application in recording mode.                      #
#                                                                              #
# @usage       startNmon                                                       #
# @in          none                                                            #
# @return      none                                                            #
# @return-code                                                                 #
#              none                                                            #
# @exit-code                                                                   #
#              none                                                            #
#------------------------------------------------------------------------------#
startNmon()
{
   vCmdArg="-ftdMAV^" # nmon command arguments
   vNmonLogDir="/var/log/nmon"
   vSnapInterval=900  # 15 minutes
   vDaySeconds=86400  # number of seconds in a day

   vHour=$(date "+%H")
   vMinute=$(date "+%M")
   vSecond=$(date "+%S")

   let vSecondsLeft="(${vSecondsDay} - ((60 * 60 * ${vHour}) - (60 * ${vMinute}) - ${vSecond}))"
   let vSnapSamples= "${vSecondsLeft} / ${vSnapInterval}"

   nmon ${vCmdArg} -c ${vSnapSamples} -s ${vSnapInterval} -m ${vNmonLogDir}
   return $?
}

#---------------------------     MAIN SECTION     -----------------------------#
parse
startNmon
exit $?
