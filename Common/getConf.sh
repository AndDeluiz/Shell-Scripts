#!/bin/sh
################################################################################
# @author      Anderson Deluiz (Twitter: @AndDeluiz)                           #
# @name        getConf.sh                                                      #
# @version     0.5                                                             #
# @date        June 2nd, 2014                                                  #
# @description Gets various configurations from running system                 #
# @usage       getConf.sh                                                      #
################################################################################

#---------------------------    DEBUG OPTIONS     -----------------------------#
# set -x    # print a trace of simple commands and their arguments
# set -v    # print shell input lines as they are read
# set -n    # read commands but do not execute them

#---------------------------   GLOBAL VARIABLES   -----------------------------#
vMyName=$(basename $0)
vOSName=$(uname -s)

#---------------------------       FUNCTIONS      -----------------------------#
usage()
{
   echo "${vMyName}: gets configurations from running system"
   echo "   ${vMyName} [-Hhvx]"
   echo
   echo "   H - generate report in HTML format (Not yet implemented)"
   echo "   h - display this message and exit"
   echo "   v - gather information about VIO Server"
   echo "   x - generate report in XML format (Not yet implemented)"
   echo
   exit 255
}

parse()
{
   while getopts hv vCmdArg
   do
      case ${vCmdArg} in
         'h')
            usage
            ;;
         'v')
            isVIOS=1
            ;;
         *)
            echo "ERROR: -${vCmdArg} Invalid option"
            usage
            ;;
            
      esac
   done
}

getConfLinux()
{
   for vSection in system kernel cpu memory swap pci disk multipath pvs vgs lvs df limits network dns ntp services
   do
      echo "========================================================================"
      echo "SECTION: ${vSection}"
      echo "------------------------------------------------------------------------"
      case ${vSection} in
         'system')
            echo "---- Hardware"
            dmidecode -t system
            ;;
         'kernel')
            echo "---- Running Kernel version"
            uname -a
            echo
            cat /etc/redhat-release
            echo "---- /etc/sysctl.conf file"
            cat /etc/sysctl.conf
            echo "---- Running kernel settings"
            sysctl -a
            ;;
         'cpu')
            echo "---- Installed CPU settings"
            cat /proc/cpuinfo
            ;;
         'memory')
            echo "---- Physical and virtual memory"
            free -m
            ;;
         'swap')
            echo "---- Swap space settings"
            swapon -s
            ;;
         'pci')
            echo "---- PCI devices installed"
            lspci
            ;;
         'disk')
            echo "---- Physical disks partitions"
            fdisk -l
            ;;
         'multipath')
            echo "---- Multipath configured devices"
            multipath -ll
            ;;
         'pvs')
            echo "---- LVM Physical Volumes"
            pvs
            ;;
         'vgs')
            echo "---- LVM Volume Groups"
            vgs
            ;;
         'lvs')
            echo "---- LVM Logical Volumes"
            lvs
            ;;
         'df')
            echo "---- Mounted filesystems settings"
            mount
            echo "---- Mounted filesystems disk usage"
            df -mI
            ;;
         'limits')
            echo "---- /etc/security/limits.conf file"
            cat /etc/security/limits.conf
            ;;
         'network')
            echo "---- Network Interfaces"
            ifconfig -a
            ;;
         'dns')
            echo "---- DNS resolver settings"
            cat /etc/resolv.conf
            ;;
         'ntp')
            echo "---- Check if NTP service is installed"
            chkconfig --list ntpd
            echo "---- Check if NTP service is running"
            ntpq -p
            echo "---- /etc/ntp.conf config file"
            grep -v '^#' /etc/ntp.conf
            ;;
         'services')
            echo "---- Configured Network Services"
            chkconfig --list 
            echo "---- Network ports in listen mode"
            netstat -lpn
            ;;
      esac
   done
}

getconfAIX()
{
   for vSection in system dump swap mpio pvs vgs lvs df network dns ntp
   do
      echo "========================================================================"
      echo "SECTION: ${vSection}"
      echo "------------------------------------------------------------------------"
      echo
      case ${vSection} in
         'system')
            if [ $(uname -L) != "-1 NULL" ]
            then
               # this is a LPAR system
               echo "---- LPAR settings"
               lpartstat -i
            fi
            echo "---- System Configuration Information"
            prtconf
            echo "---- System Configuration Information with VPD"
            prtconf -v
            echo "---- System (sys0) attributes"
            lsattr -El sys0
            ;;
         'dump')
            echo "---- AIX dump settings"
            sysdumpdev -l
            echo "---- AIX dump estimated size in bytes"
            sysdumpdev -e
            ;;
         'swap')
            echo "---- Paging space devices settings"
            lsps -a
            ;;
         'mpio')
            echo "---- MPIO paths status"
            lspath
            ;;
         'pvs')
            echo "---- Physical volumes defined in system"
            lspv
            ;;
         'vgs')
            echo "---- Defined VGs in system"
            lsvg
            echo "---- Varied on (Online) VGs in system"
            lsvg -o
            ;;
         'lvs')
            echo "---- Defined Logical Volumes (LV) in system (Online VGs only)"
            lsvg -o | lsvg -i -l 
            ;;
         'df')
            echo "---- Mounted filesystems"
            df -gI
            echo "---- Mounted filesystems settings"
            mount
            ;;
         'network')
            echo "---- IP network interfaces"
            ifconfig -a
            ;;
         'dns')
            echo "---- DNS settings"
            cat /etc/resolv.conf
            ;;
         'ntp')
            echo "---- NTP daemon settings"
            lssrc -s xntpd
            ntpq -p
            echo "---- NTP configuration"
            grep -v '^#' /etc/ntp.conf
            ;;
      esac
   done
}

getConfVIOS()
{
   echo "========================================================================"
   echo " Virtual IO Server"
   echo "========================================================================"
   echo "------------------------------------------------------------------------"
   echo " VIOS Level"
   echo "------------------------------------------------------------------------"
   /usr/ios/cli/ioscli ioslevel
   echo "------------------------------------------------------------------------"
   echo " License Information"
   echo "------------------------------------------------------------------------"
   /usr/ios/cli/ioscli license
   echo "------------------------------------------------------------------------"
   echo " Virtual Devices"
   echo "------------------------------------------------------------------------"
   /usr/ios/cli/ioscli lsdev -virtual
   echo "------------------------------------------------------------------------"
   echo " Virtual Disk Devices"
   echo "------------------------------------------------------------------------"
   /usr/ios/cli/ioscli lsdev -type disk | grep -i 'virtual'
   echo "------------------------------------------------------------------------"
   echo " Virtual Disk Devices"
   echo "------------------------------------------------------------------------"
   /usr/ios/cli/ioscli lsdev -type adapter | grep -i 'virtual'
   echo "------------------------------------------------------------------------"
   echo " Virtual SCSI Device Mapping"
   echo "------------------------------------------------------------------------"
   /usr/ios/cli/ioscli lsmap -all
   echo "------------------------------------------------------------------------"
   echo " Virtual Network Device Mapping"
   echo "------------------------------------------------------------------------"
   /usr/ios/cli/ioscli lsmap -all -net
   echo "------------------------------------------------------------------------"
   echo " Virtual Fibre Channel (NPIV) Device Mapping"
   echo "------------------------------------------------------------------------"
   /usr/ios/cli/ioscli lsmap -all -npiv
}
#---------------------------         MAIN         -----------------------------#
parse $*

case ${vOSName} in
   'AIX')
      getConfAIX
      [ ${isVIOS} -eq 1 ] && getConfVIOS
      ;;
   'Linux')
      getConfLinux
      echo "isVIOS = ${isVIOS}"
      ;;
   *)
      usage
      ;;
esac

exit 0
