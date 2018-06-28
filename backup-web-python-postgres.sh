#!/bin/bash
# Script backup server
# Azdigi Inc.

DIR_BK=/backup/website
DIR_SITE=("/home/basichome" "/home/nhaoxahoi" "/home/tophouse")
DB_SITE=("postgresql://postgres:tavireal888123@localhost:5432/basichome_database" "postgresql://postgres:tavireal888123@localhost:5432/nhaxahoi_database" "postgresql://postgres:tavireal888123@localhost:5432/tophouse_database")
LAST_3DAY=$(date --date="6 days ago" +%A-%m-%d-%y)
NOW=$(date +%A-%m-%d-%y)

echo "==== `date -I` `date +%T` start backup on vps  ====" >> /backup/scripts/log.backup
backup_process()
{
        for number in 0 1 2
        do
                SITE_NAME=$(echo ${DIR_SITE[$number]} | awk -F'/' '{print $3}')
		DB_NAME=$(echo ${DB_SITE[$number]} | awk -F'/' '{print $4}')
                cd ${DIR_SITE[$number]}
                zip -9 -r ${DIR_BK}/${NOW}/${SITE_NAME}.source.zip ./
		pg_dump ${DB_SITE[$number]} | gzip > ${DIR_BK}/${NOW}/${DB_NAME}.sql.gz

        done
        echo "- Backup config and source web finished -" >> /backup/scripts/log.backup
		touch /var/log/${NOW}
}

if [ ! -e  /var/log/${NOW} ];then
        mkdir -p ${DIR_BK}/${NOW}/
        mkdir -p ${DIR_BK}/${NOW}/
        chmod -R 700 ${DIR_BK}/${NOW}/
        chown -R root: ${DIR_BK}/${NOW}/
        backup_process
        rclone mkdir tavireal:/backup/${NOW}/
        rclone sync ${DIR_BK}/${NOW}/ tavireal:/backup/${NOW}/
        rm -rf ${DIR_BK}/${NOW}
		 if [ -e /var/log/${LAST_3DAY} ] ; then
                        rclone purge tavireal:/backup/${LAST_3DAY}
			rm -f /var/log/${LAST_3DAY}
                        echo "- Backup remove last version completed -" >> /backup/scripts/log.backup
                else
                        echo "- Do not have backupt remove -" >> /backup/scripts/log.backup
                fi
else
        echo "- Error for creating directory backup today - Stop here" >> /backup/scripts/log.backup
        exit 0
fi


echo "- Finish backup -" >> /backup/scripts/log.backup
