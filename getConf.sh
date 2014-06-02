#!/bin/sh
################################################################################
# @author      Anderson Deluiz (Twitter: @AndDeluiz)                           #
# @name        getConf.sh                                                      #
# @version     0.3                                                             #
# @date        June 2nd, 2014                                                  #
# @description Gets various configurations from running system                 #
# @usage       getConf.sh                                                      #
################################################################################

################################################################################
# set -x
# set -v
# set -n
################################################################################

#---------------------------   GLOBAL VARIABLES   -----------------------------#
vOSName=$(uname -s)
#------------------------------------------------------------------------------#

################################################################################
# 
################################################################################
usage()
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
   for vSection in system dump swap mpio pvs vgs lvs df passwd group limits network dns ntp services
   do
      echo "========================================================================"
      echo "SECTION: ${vSection}"
      echo "------------------------------------------------------------------------"
      case ${vSection} in
         'system')
            if [ $(uname -L) != "-1 NULL" ]
            then
               # this is a LPAR system
               lpartstat -i
            fi
            echo "\n------------------------------------------------------------------------\n"
            prtconf
            echo "\n------------------------------------------------------------------------\n"
            prtconf -v
            echo "\n------------------------------------------------------------------------\n"
            lsattr -El sys0
            ;;
         'dump')
            sysdumpdev -l
            ;;
         'swap')
            lsps -a
            ;;
         'mpio')
            lspath
            ;;
         'pvs')
            lspv
            ;;
         'vgs')
            echo "\n------------------------------------------------------------------------\n"
            echo "Defined VGs in system"
            echo "\n------------------------------------------------------------------------\n"
            lsvg
            echo "\n------------------------------------------------------------------------\n"
            echo "Varied on (Online) VGs in system"
            echo "\n------------------------------------------------------------------------\n"
            lsvg -o
            ;;
         'lvs')
            echo "\n------------------------------------------------------------------------\n"
            echo "Defined Logical Volumes (LV) in system (Online VGs only)"
            echo "\n------------------------------------------------------------------------\n"
            lsvg -o | lsvg -i -l 
            ;;
         'df')
            df -gI
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
