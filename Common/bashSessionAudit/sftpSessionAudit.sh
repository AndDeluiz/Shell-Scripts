#!/bin/bash
################################################################################
# @author      Anderson Deluiz (Twitter: @AndDeluiz)                           #
# @name        sftpSessionAudit.sh                                             #
# @version     1.0                                                             #
# @date        Aug 15th, 2014                                                  #
# @description Logs commands submitted by sftp/scp sessions                    #
#              This script adds audit funcionality to sftp/scp sessions by     #
#              using bashSessionAudit.sh script. So it is mandatory that       #
#              bashSessionAudit.sh is installed and working. Instructions on   #
#              to obtain bashSessionAudit.sh script can be found at @require   #
#              session.                                                        #
#              This script must be called by sshd daemon using ForceCommand    #
#              directive in sshd_config file. What it does is to call bash as  #
#              an interactive session to handle scp/sftp sessions. Doing this  #
#              user profile will be executed as an interactive session and     #
#              therefore bashSessionAudit.sh will be executed.                 #
#                                                                              #
#              This script is based on forcecommand.sh script written by       #
#              Francois Scheurer from Point Software AG, available at:         #
#              http://goo.gl/Sjx0ti                                            #
#                                                                              #
# @require     - Syslog (or rsyslog) daemon configured and working             #
#              - Bash shell version 4 or later                                 #
#              - bashSessionAudit.sh script installed and working (can be      #
#                found at http://github.com/AndDeluiz/Shell-Scripts/Commom)    #
#                                                                              #
# @usage       As root user:                                                   #
#              1. Copy this file to a local directory. Eg.: /etc/sshd          #
#              2. Change permissions to 0755 and owner/group to root/root.     #
#                 Directory must also be owned by root and must have r-x       #
#                 permissions for other users to avoid script substitution.    #
#              3. Configure sshd by adding following line to /etc/sshd_config: #
#                                                                              #
#                 ForceCommand "/path/to/sftpSessionAudit.sh"                  #
#                                                                              #
#              4. Reload SSH daemon configuration.                             #
################################################################################

#---------------------------   GLOBAL VARIABLES   -----------------------------#


#---------------------------     MAIN SECTION     -----------------------------#

if [ -n "${SSH_ORIGINAL_COMMAND}" ]
then
   # SSH interactive session
   exec bash -c "${SSH_ORIGINAL_COMMAND}"
else
   # SFTP/SCP session
   exec -l bash -li
fi
