#!/bin/bash
#############################################################################################################
#
#!/bin/ksh
#############################################################################################################
#
# rman_backup.sh
#
# Takes full database backup along with the existing archive logs in the disk. Once the backup gets completed,
# removes the RMAN backup files that are not required
# to restore the database files older than 7 days.
#
# This script needs 1 parameters.
# 1 - Backup Type
#############################################################################################################
TNSNAME=DBCLI
ORACLE_SID=dbcli1
NODE_NAME=oims-rj-dbcli1
BACKUP_LOCATION=/bareos/PTIN/SEC/Oracle/CLI
LOG_LOCATION=/bareos/PTIN/SEC/Oracle/CLI
prog=backup_rman
LAST_MONTH=`date +%Y%m --date="last month"`
RESULT="$BACKUP_LOCATION/move_log.log"
ORACLE_HOME=/u01/app/oracle/product/11.2.0/db_1
PATH=$PATH:${ORACLE_HOME}:${ORACLE_HOME}/bin
export ORACLE_SID
export ORACLE_HOME
export PATH

move_logs () {
files=`find /backup/oracle/rman_full_arqos_disk_$LAST_MONTH*|sort -n`
tar zcvf $BACKUP_LOCATION/$LAST_MONTH.tar.gz $files --remove-files >$RESULT
 mailx -s "TAR backup logfiles from $LAST_MONTH to rman_full_arqos_disk$LAST_MONTH.tar.gz" oracle < $RESULT
}

database () {
rman append log  ${LOG_LOCATION}/rman_full_${TNSNAME}_disk.log <<EOF
connect target sys/oracle$2014OI\@${TNSNAME}
 run {
CROSSCHECK ARCHIVELOG ALL;
CROSSCHECK BACKUP;
delete noprompt obsolete;
delete noprompt expired backup;
backup format '$BACKUP_LOCATION/$TNSNAME<$ORACLE_SID\_\%d:\%s:\%p:\%t>.dbf' as compressed backupset database;
sql  'alter system archive log current';
backup archivelog all delete input format '$BACKUP_LOCATION/thread_<\%t_\%s>.ARC';
delete noprompt obsolete;
delete noprompt expired backup;
}
exit
EOF
}

archivelogs () {
rman append log  ${LOG_LOCATION}/rman_arch_${TNSNAME}_disk.log <<EOF
connect target sys/oracle$2014OI\@${TNSNAME}
 run {
CROSSCHECK ARCHIVELOG ALL;
CROSSCHECK BACKUP;
delete noprompt obsolete;
delete noprompt expired backup;
sql  'alter system archive log current';
backup archivelog all delete input format '$BACKUP_LOCATION/thread_<\%t_\%s>.ARC';
delete noprompt obsolete;
delete noprompt expired backup;
}
exit
EOF
}

list () {
rman target / <<EOF
list backup;
exit
EOF
}

#Check crs resource state on this node
RUNNING=$(/u01/app/11.2.0/grid_1/bin/crsctl status res infra.bckp.cron -n $NODE_NAME | grep STATE | grep ONLINE | wc -l)
if [ $RUNNING -eq 0 ]; then
       echo "Oracle backup should not be run on this node . Check CRS resource infra.bckp.cron status"
       RETVAL=2
else

case "$1" in
  database)
        database
        ;;
  list)
        list
        ;;
  archivelogs)
        archivelogs
        ;;
  move_logs)
        move_logs
        ;;
  *)
        echo $"Usage: $prog {database|archivelogs|list} to backup database/archivelogs or list backup of database"
        RETVAL=2
esac
fi

exit $RETVAL
