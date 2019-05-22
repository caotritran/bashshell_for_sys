#!/bin/bash
#Script backup daily influxdb
#Source: Cinatic Server Team

DATE=`/usr/bin/date +%d%m%y`
PATH=/tmp/influxdb_backup_daily
PATH_LOG=/var/log/influxdb_backup
DB_NAME=tn001_metric_db
timestamp=`/usr/bin/date "+%Y-%m-%d %H:%M:%S"`

MAIN_BACKUP(){
        if [ ! -d $PATH ]; then
                /usr/bin/mkdir $PATH
        fi

        if [ ! -d $PATH_LOG ]; then
                /usr/bin/mkdir $PATH_LOG
        fi

        #Check last 7 days then delete
        /usr/bin/find $PATH -type f -mtime +7 -exec /usr/bin/rm -rf {} \;
        #Run backup
        /usr/bin/timeout 50s /usr/bin/influxd backup -database $DB_NAME /tmp/influxdb_backup/ >/dev/null 2>&1
        if [ $? -eq 0 ]; then
                cd $PATH
                /usr/bin/zip -r backup-influxdb-$DATE.zip /tmp/influxdb_backup/*
                #/usr/bin/rm -rf /tmp/influxdb_backup >/dev/null 2>&1
                echo "$timestamp: backup success" >> $PATH_LOG/influxd-backup.log
        else
                echo "$timestamp: backup failed" >> $PATH_LOG/influxd-backup.log
        fi
        /usr/bin/rm -rf /tmp/influxdb_backup >/dev/null 2>&1
}

MAIN_BACKUP
