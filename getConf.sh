#!/bin/bash
################################################################################
# @author      Anderson Deluiz (anderson.deluiz at gmail dot com)              #
# @name        getConf.sh                                                      #
# @version     0.3                                                             #
# @description Gets various configurations from running system                 #
#
################################################################################
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
