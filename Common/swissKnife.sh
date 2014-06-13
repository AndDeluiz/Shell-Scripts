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
#              253 - Running user is not root                                  #
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
# @function    checkSysCore                                                    #
# @description Check system core file to detect crashing application (AIX only)#
#                                                                              #
# @usage       checkCore <file>                                                #
# @in          file - core file name and location                              #
# @return      none                                                            #
# @return-code                                                                 #
#              0 - Success                                                     #
#              1 - Core file doesn't exist or isn't readable                   #
#------------------------------------------------------------------------------#
checkSysCore()
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
   echo "INFO: extended data for $1 file"
   echo "stat\n status\n t -m" | crash $1
   return $?
}

#------------------------------------------------------------------------------#
# @function    checkAppCore                                                    #
# @description Check application core file (AIX Only)                          #
# @usage       checkCoreFile <file>                                            #
# @in          file - Path to core file                                        #
# @return      none                                                            #
# @return-code                                                                 #
#              0 - Success                                                     #
#              1 - Core file doens't exist or isn't readable by user           #
#------------------------------------------------------------------------------#
checkAppCore()
{
   checkOS $0 AIX \
      || {
            echo "$0: this function only works with AIX."
            exit 254
         }

   [ -r $1 ] \
      || {
            echo "ERROR: File $1 does not exist or does not have read permission."
            return 1
         }
   local vCoreApp
   local vCoreAppPath
   
   vCoreApp=$(/usr/lib/ras/check_core $1 | tail -1)
   vCoreAppPath=$(type ${vCoreApp})
   echo "INFO: Core file generated by ${vCoreApp} application"
   echo "INFO: Path to ${vCoreApp} application is ${vCoreAppPath}"
   echo "INFO: Additional core file info"
   dbx ${vCoreAppPath} $1
}

#------------------------------------------------------------------------------#
# @function    checkDumpfile                                                   #
# @description Check dumpfile to detect crashing application (Linux only)      #
# @usage       checkDump <file>                                                #
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
      lquerypv -h /dev/$1 20 10 | fgrep '4F52434C 4449534B' > /dev/null
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

#------------------------------------------------------------------------------#
# @function    findTCPPortPid                                                  #
# @description Find PID using a TCP port.                                      #
# @usage       findTCPPortPid TCPPort                                          #
# @in          TCPPort - TCP Port to be checked.                               #
# @return      none                                                            #
# @return-code                                                                 #
#              0 - Success                                                     #
#              1 -                                                             #
#------------------------------------------------------------------------------#
findTCPPortPid()
{
   checkOS $0 AIX \
      || {
            echo "$0: this function only works with AIX."
            exit 254
         }

   [ $# -ne 1 ] \
      && {
            echo "$0(): wrong number of parameters"
            exit -1
         }

   local vSocketID
   local vPID
   vSocketID=$(netstat -Aan | grep $1 | awk '{print $1}')
   vPID=$(rmsock ${vSocketID} tcpcb | awk '{print $9}')
   ps -o user,group,pid,ppid,etime,args -p ${vPID}
}

#------------------------------------------------------------------------------#
# @function    dropFSCache                                                     #
# @description Clean filesystem cache in Linux (must be root)                  #
# @usage       dropFSCache <number>                                            #
# @in          number - Integer value from 1 to 3                              #
#                       1 - free pagecache                                     #
#                       2 - free dentries and inodes                           #
#                       3 - free pagecache, dentries and inodes                #
# @return      none                                                            #
# @return-code                                                                 #
#              0 - Success                                                     #
#              1 -                                                             #
#------------------------------------------------------------------------------#
dropFSCache()
{
   checkOS $0 Linux \
      || {
            echo "$0: this function only works with Linux."
            exit 254
         }

   [ $# -ne 1 ] \
      && {
            echo "$0(): wrong number of parameters"
            exit -1
         }

   if [ $(id -un) = 'root' ]
   then
      echo "INFO: Actual cache size = $(free -m | awk '/^Mem:/ ~ {print $6"+"$7}' | bc) MB"
      echo "INFO: Performing cache cleaning. This may take a while..."
      sysctl -w vm.drop_caches=3 > /dev/null \
         && {
               echo "INFO: Done"
               sysctl -w vm.drop_cache=0 > /dev/null 2>&1
               return 0
            } \
         || {
               echo "ERROR: Could not perform command. Check errors above."
               return 1
            }
   else
      echo "ERROR: Must be root to perform $0."
      exit 253
   fi
   
   return 0
}

#------------------------------------------------------------------------------#
# @function    getFreeMem                                                      #
# @description Get free memory size in MB                                      #
# @usage       getFreeMem                                                      #
# @in          none                                                            #
# @return      none                                                            #
# @return-code                                                                 #
#              0 - Success                                                     #
#              1 -                                                             #
#------------------------------------------------------------------------------#
getFreeMem()
{
   checkOS $0 AIX \
      || {
            echo "$0: this function only works with AIX."
            exit 254
         }
         
   echo "INFO: Calculating AIX free RAM..."
   echo "INFO: Free RAM = $(vmstat -Iwt 2 1 | tail -1 | awk '{print $5,"*4/1024"}' | bc) MB"
   return 0
}

#------------------------------------------------------------------------------#
# @function    checkCoreFile                                                   #
# @description Prints information about a given core file                      #
# @usage       checkCoreFile <core>                                            #
# @in          core - Path to core file                                        #
# @return      none                                                            #
# @return-code                                                                 #
#              0 - Success                                                     #
#              1 - Core file doens't exist or isn't readable by user           #
#------------------------------------------------------------------------------#
checkCoreFile()
{
   checkOS $0 AIX \
      || {
            echo "$0: this function only works with AIX."
            exit 254
         }

   [ -r $1 ] \
      || {
            echo "ERROR: File $1 does not exist or does not have read permission."
            return 1
         }
   local vCoreApp
   local vCoreAppPath
   
   vCoreApp=$(/usr/lib/ras/check_core $1 | tail -1)
   vCoreAppPath=$(type ${vCoreApp})
   echo "INFO: Core file generated by ${vCoreApp} application"
   echo "INFO: Path to ${vCoreApp} application is ${vCoreAppPath}"
   echo "INFO: Additional core file info"
   dbx ${vCoreAppPath} $1
}

#------------------------------------------------------------------------------#
# @function    listIOPath                                                      #
# @description Print paths to I/O devices (MPIO - AIX / Multipath - Linux)     #
# @usage       listIOPath                                                      #
# @in          none                                                            #
# @return      none                                                            #
# @return-code                                                                 #
#              0 - Success                                                     #
#              1 - Core file doens't exist or isn't readable by user           #
#------------------------------------------------------------------------------#
listIOPath()
{
   case ${vOSName} in
      'AIX')
         lspath -F "name path_id parent connection status"
         ;;
      'Linux')
         multipath -ll
         ;;
   esac
}

#------------------------------------------------------------------------------#
# @function    checkFCAdapter                                                  #
# @description Check Fibre Channel adapter device                              #
# @usage       checkFCAdapter                                                  #
# @in          none                                                            #
# @return      none                                                            #
# @return-code                                                                 #
#              0 - Success                                                     #
#              1 - Core file doens't exist or isn't readable by user           #
#------------------------------------------------------------------------------#
checkFCAdapter()
{
   case ${vOSName} in
      'AIX')
         for vAdapter in $(lsdev -Cc adapter | sed '/^fcs[0-9]/s/ .*//')
         do
            echo "================================================================================"
            fcstat ${vAdapter}
         done
         ;;
      'Linux')
         systool -c scsi_host -v
         ;;
   esac
}
#---------------------------     MAIN SECTION     -----------------------------#

eval $1

exit $?
