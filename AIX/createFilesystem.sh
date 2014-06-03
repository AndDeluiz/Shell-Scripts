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
# set -x    # print a trace of simple commands and their arguments
# set -v    # print shell input lines as they are read
# set -n    # read commands but do not execute them

#---------------------------   GLOBAL VARIABLES   -----------------------------#
vMyname=$(basename $0)
vOSName=$(uname -s)

#---------------------------       FUNCTIONS      -----------------------------#
usage()
{
   echo "${vMyname}: Display commands for creating JFS2 filesystems based on a CSV file"
   echo
   echo "usage: ${vMyname} <CSV file name>"
   echo
   echo "CSV file format:"
   echo "MountPoint,LVName,LVSize,VGName,User,Group,Permissions,Option,FSLog"
   echo
   echo "Where:"
   echo "   MountPoint - mount point of new jfs2 filesystem"
   echo "   LVName - new logical volume name"
   echo "   LVSize - new logical volume size"
   echo "   VGName - volume group name"
   echo "   User - user owner of new jfs2 filesystem mount point (default: root)"
   echo "   Group - group owner of new jfs2 filesystem mount point (default: system)"
   echo "   Permission - Permissions (octal mode) of new jfs2 filesystem mount point (default: 750)"
   echo "   Option - optional jfs2 filesystem mount options (separeted by dots. eg.: rw.cio)"
   echo "   FSLog - optional jfs2 filesystem log device (default: existing log device in VG)"
   echo
   echo "Example:"
   echo "/app01,lvapp01,1,rootvg,appusr,appgrp,755,rbrw.cio.dio,INLINE"
   echo "/app02,lvapp02,1,rootvg,appusr,appgrp,775,rbrw,"
   echo "/app03,lvapp03,1,rootvg,appusr,appgrp,700,,INLINE"
   echo "/app04,lvapp04,1,rootvg,appusr,appgrp,755,,"
   exit 255
}

#---------------------------     MAIN SECTION     -----------------------------#
vInputFile=$1

if [ $vOSName != 'AIX' ]
then
   usage
fi

if ! [ -r "${vInputFile}" ]
then
   echo "ERROR: Specify name of input CSV file on command line"
   usage
fi

cat "${vInputFile}" \
   |  grep '^/' \
      |  while read line
         do
            mount=$(echo $line | awk -F, '{print $1}')
            lv=$(echo $line | awk -F, '{print $2}')
            size=$(echo $line | awk -F, '{print $3}')
            vg=$(echo $line | awk -F, '{print $4}')
            user=$(echo $line | awk -F, '{print $5}')
            group=$(echo $line | awk -F, '{print $6}')
            perm=$(echo $line | awk -F, '{print $7}')
            options=$(echo $line | awk -F, '{print $8}')
            log=$(echo $line | awk -F, '{print $9}')

            echo "( mkdir -p $mount &&"
            echo "mklv -y $lv -t jfs2 -L $lv $vg ${size}G &&"
            myoptions=""
            mylog=""
            
            if ! [ -z "$options" ]
            then
               myoptions="-a options=$(echo $options | tr '.' ',' | tr -d ' ')"
            fi
            
            if ! [ -z "$log" ]
            then
               mylog="-a logname=$log"
            fi
            
            echo "crfs -v jfs2 -d $lv -m $mount -A yes -p rw $myoptions $mylog &&"
            echo "mount $mount &&"
            echo "chown ${user}:${group} $mount &&"
            echo "chmod $perm $mount ) &&"
            echo "echo \"$mount created successfully\" ||"
            echo "echo \"ERROR creating $mount\""
            echo "echo"
            echo
         done

exit 0
