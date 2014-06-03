#!/bin/sh
################################################################################
# @author      Anderson Deluiz (Twitter: @AndDeluiz)                           #
# @name        getConf.sh                                                      #
# @version     0.3                                                             #
# @date        June 2nd, 2014                                                  #
# @description Gets various configurations from running system                 #
# @usage       getConf.sh                                                      #
################################################################################

#---------------------------    DEBUG OPTIONS     -----------------------------#
# set -x
# set -v
# set -n

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
   echo "   v - display version and exit"
   echo "   x - generate report in XML format (Not yet implemented)"
   echo
   exit 255
}

parse()
{
   :
}

getConfLinux()
{
   for vSection in system kernel cpu memory swap pci disk multipath pvs vgs lvs df passwd group limits network dns ntp services
   do
      echo "========================================================================"
      echo "SECTION: ${vSection}"
      echo "------------------------------------------------------------------------"
      case ${vSection} in
         'system')
            dmidecode -t system
            ;;
         'kernel')
            uname -a
            echo
            cat /etc/redhat-release
            echo "******************** /etc/sysctl.conf *******************"
            cat /etc/sysctl.conf
            echo "******************** sysctl -a *******************"
            sysctl -a
            ;;
         'cpu')
            cat /proc/cpuinfo
            ;;
         'memory')
            free -m
            ;;
         'swap')
            swapon -s
            ;;
         'pci')
            lspci
            ;;
         'disk')
            fdisk -l
            ;;
         'multipath')
            multipath -ll
            ;;
         'pvs')
            pvs
            ;;
         'vgs')
            vgs
            ;;
         'lvs')
            lvs
            ;;
         'df')
            df -gI
            ;;
         'passwd')
            cat /etc/passwd
            ;;
         'group')
            cat /etc/group
            ;;
         'limits')
            cat /etc/security/limits.conf
            ;;
         'network')
            ifconfig -a
            ;;
         'dns')
            cat /etc/resolv.conf
            ;;
         'ntp')
            chkconfig --list ntpd
            ntpq -p
            echo "******************** /etc/ntp.conf *******************"
            grep -v '^#' /etc/ntp.conf
            ;;
         'services')
            chkconfig --list 
            echo "******************** Running Network Services *******************"
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

#---------------------------         MAIN         -----------------------------#
