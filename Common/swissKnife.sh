#!/bin/sh
################################################################################
# @author      Anderson Deluiz (Twitter: @AndDeluiz)                           #
# @name        swissKnife.sh                                                   #
# @version     0.1                                                             #
# @date        June 06, 2014                                                   #
# @description This is a swiss knife script plenty of useful functions that may#
#              be used in IBM AIX or Red Hat Enterprise Linux (may work with   #
#              other distros as well).                                         #
#                                                                              #
# @usage       swissKnife.sh <function-name>                                   #
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
   :
   exit 255
}
#------------------------------------------------------------------------------#
# @function    exitDoor                                                        #
# @description Display exit message based on received parameters and exit      #
#                                                                              #
# @usage       usage                                                           #
# @in          none                                                            #
# @return      none                                                            #
# @return-code                                                                 #
#              none                                                            #
# @exit-code                                                                   #
#              255 - normal exit code                                          #
#------------------------------------------------------------------------------#
exitDoor()
{
   :
}
#------------------------------------------------------------------------------#
# @function    checkProcPageSpace                                              #
# @description #
#                                                                              #
# @usage       usage                                                           #
# @in          none                                                            #
# @return      none                                                            #
# @return-code                                                                 #
#              none                                                            #
# @exit-code                                                                   #
#              255 - normal exit code                                          #
#------------------------------------------------------------------------------#
checkProcPageSpace
{
   [ ${vOSName} != "AIX" ] && exitDoor 1 checkProcPageSpace
   echo "     Pid Command          Inuse      Pin     Pgsp  Virtual 64-bit Mthrd LPage"
   svmon -P | \
      awk ' BEGIN {FLAG=0}
                  {
                     if ( $5 == "Pgsp" )
                        FLAG=1;
                     else
                     {
                        if ( FLAG == 1 )
                        {
                           print $0;
                           FLAG=0;
                        }
                     }
                  }' |\
      sort -n -r +5
}

#---------------------------     MAIN SECTION     -----------------------------#
exit 0
