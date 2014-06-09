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
# @license     GPLv3 - GNU Public License version 3                            # 
# @exit-code                                                                   #
#               -1 - Internal error (wrong parameter number, etc.)             #
#              254 - Wrong operating system                                    #
#              255 - Wrong program usage                                       #
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
#------------------------------------------------------------------------------#
usage()
{
   echo "usage: ${vMyName} [-hlv] [name] [param1 param2 param3 ...]"
   echo
   echo "Options:"
   echo "   -h    Display this message and exit."
   echo "   -l    List available funcions and descriptions"
   echo "   -v    Display version number and exit."
   echo
   exit 255
}

#------------------------------------------------------------------------------#
# @function    parse                                                           #
# @description Parse command line options                                      #
# @usage       parse                                                           #
# @in          none                                                            #
# @return      none                                                            #
# @return-code                                                                 #
#              none                                                            #
#------------------------------------------------------------------------------#
parse()
{
#TODO
   :
}

#------------------------------------------------------------------------------#
# @function    checkOS                                                         #
# @description Check OS name and version/distribution.                         #
#                                                                              #
# @usage       checkOS function OSname [release]                               #
# @in          none                                                            #
# @return      none                                                            #
# @return-code                                                                 #
#              0 - sucess                                                      #
#              1 - wrong OS Name                                               #
#              2 - wrong OS version                                            #
#------------------------------------------------------------------------------#
checkOS()
{
   [ $# -lt 2 ] && {
                      echo "$0(): wrong number of parameters"
                      exit -1
                   }

   case ${vOSName} in
      'AIX')
         vOSVersion=$(oslevel)
         if [ $# -eq 3 ]
         then
            [ '$3' != "${vOSVersion}" ] && return 2
         fi
         return 0
         ;;
      'Linux')
         return 0
         ;;
   esac
   return 1
}

#------------------------------------------------------------------------------#
# @function    checkProcPageSpace                                              #
# @description Displays processes paging space use in descending order.        #
#                                                                              #
# @usage       checkProcPageSpace                                              #
# @in          none                                                            #
# @return      none                                                            #
# @return-code                                                                 #
#              none                                                            #
#------------------------------------------------------------------------------#
checkProcPageSpace()
{
   checkOS $0 AIX \
      || {
            echo "$0: this function only works with AIX."
            exit 254
         }
                              
   echo "$0: Checking paging space use. This may take a while..."
   echo
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

#------------------------------------------------------------------------------#
# @function    getPVID                                                         #
# @description Reads PVID directly from hdisk                                  #
# @usage       getPVID PVName                                                  #
# @in          PVName - Physical Volume Name                                   #
# @return      PVID                                                            #
# @return-code                                                                 #
#              0 - Success                                                     #
#              1 - Device (PVName) not available                               #
#------------------------------------------------------------------------------#
getPVID()
{
   [ $# -ne 1 ] && {
                      echo "$0(): wrong number of parameters"
                      exit -1
                   }
   
   local vHDISK
   local vPVID
   vHDISK="/dev/$1"
   
   checkOS $0 AIX \
      || {
            echo "$0: this function only works with AIX."
            exit 254
         }
   
   if [ $(lsdev -l ${vHDISK#*/} | cut -f 2) = "available" ]
   then
      echo "INFO: Device ${vHDISK} seems to be available. Checking PVID..."
      vPVID=$(lquerypv -h ${vHDISK} 80 10 | cut -f2-3 | tr -d ' ')
      echo "${vHDISK}: ${vPVID}"
      return 0
   fi
   echo "INFO: Device ${vHDISK} is not available on this system."
   return 1
}

#------------------------------------------------------------------------------#
# @function    getVGDA                                                         #
# @description Reads VGDA directly from hdisk                                  #
# @usage       getVGDA PVName                                                  #
# @in          PVName - Physical Volume Name                                   #
# @return      VGDA                                                            #
# @return-code                                                                 #
#              0 - Success                                                     #
#              1 - Device (PVName) not available                               #
#------------------------------------------------------------------------------#
getVGDA()
{
   [ $# -ne 1 ] && {
                      echo "$0(): wrong number of parameters"
                      exit -1
                   }
   
   local vHDISK
   local vVGDA
   vHDISK="$1"
   
   checkOS $0 AIX \
      || {
            echo "$0: this function only works with AIX."
            exit 254
         }
   
   if [ $(lsdev -l ${vHDISK} | cut -f 2) = "available" ]
   then
      echo "INFO: Device ${vHDISK} seems to be available. Checking VGDA..."
      lqueryvg -Atvp ${vHDISK} && return 0
   fi
   echo "INFO: Device ${vHDISK} is not available on this system."
   return 1
}

#------------------------------------------------------------------------------#
# @function    checkCore                                                       #
# @description Check core file to detect crashing application                  #
# @usage       checkDump file                                                  #
# @in          file - core file name and location                              #
# @return      none                                                            #
# @return-code                                                                 #
#              0 - Success                                                     #
#              1 - Core file doesn't exist or isn't readable                   #
#------------------------------------------------------------------------------#
checkCore()
{
   checkOS $0 AIX \
      || {
            echo "$0: this function only works with AIX."
            exit 254
         }

   [ $# -ne 1 ] && {
                      echo "$0(): wrong number of parameters"
                      exit -1
                   }

   [ -r $1 ] || {
                   echo "$0(): file $1 is not readable or does not exist"
                   return 1
                }

   echo "INFO: checking $1 file..."
   lquerypv -h $1 6b0 64
   return $?
}

#------------------------------------------------------------------------------#
# @function    checkDumpfile                                                   #
# @description Check dumpfile to detect crashing application                   #
# @usage       checkDump file                                                  #
# @in          file - core file name and location                              #
# @return      none                                                            #
# @return-code                                                                 #
#              0 - Success                                                     #
#              1 - Dumpfile doesn't exist or isn't readable                    #
#------------------------------------------------------------------------------#
checkDumpfile()
{
   checkOS $0 Linux \
      || {
            echo "$0: this function only works with Linux."
            exit 254
         }

   [ $# -ne 1 ] && {
                      echo "$0(): wrong number of parameters"
                      exit -1
                   }

   [ -r $1 ] || {
                   echo "$0(): file $1 is not readable or does not exist"
                   return 1
                }

   echo "INFO: checking $1 file..."
   echo "stat\n status\n t -m" | crash $1
   return $?
}

#------------------------------------------------------------------------------#
# @function    listOpenFiles                                                   #
# @description List files open by a process                                    #
# @usage       listOpenFiles PID                                               #
# @in          PID - process ID number                                         #
# @return      none                                                            #
# @return-code                                                                 #
#              0 - Success                                                     #
#              1 - invalid PID number                                          #
#------------------------------------------------------------------------------#
listOpenFiles()
{
   [ $# -ne 1 ] && {
                      echo "$0(): wrong number of parameters"
                      exit -1
                   }

   case ${vOSName} in
      'AIX')
         procfiles -cn $1
         return $?
         ;;
      'Linux')
         lsof -p $1
         return $?
         ;;
   esac
}

#------------------------------------------------------------------------------#
# @function    checkASMDisk                                                    #
# @description Check if a disk is in use by ORACLE ASM                         #
# @usage       checkASMDisk DISK                                               #
# @in          DISK - Disk device name                                         #
# @return      none                                                            #
# @return-code                                                                 #
#              0 - Success                                                     #
#              1 - Disk device not available                                   #
#------------------------------------------------------------------------------#
checkASMDisk()
{
   checkOS $0 AIX \
      || {
            echo "$0: this function only works with AIX."
            exit 254
         }

   [ $# -ne 1 ] && {
                      echo "$0(): wrong number of parameters"
                      exit -1
                   }

   if [ $(lsdev -l $1 | cut -f 2) = "Available" ]
   then
      echo "INFO: Device $1 seems to be available. Checking PV header..."
      lquerypv -h /dev/$1 20 10 | fgrep "4F52434C 4449534B" > /dev/null
      if [ $? -eq 0 ]
      then
         echo "INFO: Device $1 is labeled as an Oracle ASM volume."
         return 0
      else
         echo "INFO: Device $1 is NOT labeled as an Oracle ASM volume"
         return 0
      fi
   fi
   echo "INFO: Device $1 is not available on this system."
   return 1
}

#---------------------------     MAIN SECTION     -----------------------------#
exit $?
