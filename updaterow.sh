#!/bin/bash

list_db=`mysql -e "SHOW DATABASES;" | grep -Ev "(Database|information_schema|performance_schema|mysql)"`

#list_db=("aggretsukoZh_data" "danganronp3V_data" "test_data" "darlingintBx_data")

for i in ${list_db[@]}; do 
    mysql $i -e "UPDATE wp_posts SET post_status = 'wc-shipped-shipment' WHERE post_status = 'shipped-shipment';"
    #echo "$?"
    if [[ $? -ne 0 ]]; then
        echo "update fail on database $i" >> /var/log/update_db.log
    else
        echo "update success on database $i" >> /var/log/update_db.log
    fi
done
