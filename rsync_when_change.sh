#/bin/bash
#Author: tritran
#Script check change file to sync to Server Openvpn02

md5=`md5sum /etc/openvpn/easy-rsa/pki/index.txt | awk '{print $1}'`
RSYNC_PASSWORD='password_here'

echo "$md5"

if [ ! -f md5check.txt ]; then
	echo "$md5" > md5check.txt
	md5_before=`cat md5check.txt`
else
	md5_before=`cat md5check.txt`
fi

echo "$md5_before"

if [ "$md5" != "$md5_before" ]; then
	#rsync -avzh $args --password-file=rsync_pass.txt root@45.xxx.xxx.xxx:/etc/openvpn
	#sshpass -p $RSYNC_PASSWORD rsync -avzh /etc/openvpn root@45.xxx.xxx.xxx:/etc/
	rsync -avzh -e 'ssh -i /root/.ssh/openvpn02' /etc/openvpn/ root@45.xxx.xxx.xxx:/etc/
	if [ $? -eq 0 ]; then
		if [ ! -f /var/log/syncopenvpn.log ]; then
			touch /var/log/syncopenvpn.log
			echo -e "md5 check file not equal, start sync at `date`" >> /var/log/syncopenvpn.log
		else
			echo -e "md5 check file not equal, start sync at `date`" >> /var/log/syncopenvpn.log
		fi
		echo "$md5" > md5check.txt
	else
		if [ ! -f /var/log/syncopenvpn.log ]; then
			touch /var/log/syncopenvpn.log
			echo -e "An error occurred, the administrator should check the problem at `date`" >> /var/log/syncopenvpn.log
		else
			echo -e "An error occurred, the administrator should check the problem at `date`" >> /var/log/syncopenvpn.log
		fi
	fi
	
	
else
	echo "value equal"
fi

==================================================================

#/bin/bash
#Author: AZDIGI CORPORATION
#Script check change file to sync to Server Openvpn02

md5=`md5sum /etc/openvpn/easy-rsa/pki/index.txt | awk '{print $1}'`
#RSYNC_PASSWORD='azdigi@2019'

echo "$md5"

if [ ! -f md5check.txt ]; then
        echo "$md5" > md5check.txt
        md5_before=`cat md5check.txt`
else
        md5_before=`cat md5check.txt`
fi

echo "$md5_before"

if [ "$md5" != "$md5_before" ]; then
        #rsync -avzh $args --password-file=rsync_pass.txt root@45.252.251.121:/etc/openvpn
        #sshpass -p $RSYNC_PASSWORD rsync -avzh /etc/openvpn root@45.252.251.121:/etc/
        ssh vpn2.azdigi.com -t 'rm -rf /etc/openvpn'
        scp -i /root/.ssh/vpnazdigi -r /etc/openvpn/ root@vpn2.azdigi.com:/etc/openvpn
        #rsync -avzh -e 'ssh -i /root/.ssh/vpnazdigi' /etc/openvpn/ root@vpn2.azdigi.com:/etc/openvpn
        ssh vpn2.azdigi.com -t 'systemctl restart openvpn@server'
        if [ $? -eq 0 ]; then
                if [ ! -f /var/log/syncopenvpn.log ]; then
                        touch /var/log/syncopenvpn.log
                        echo -e "md5 check file not equal, start sync at `date`" >> /var/log/syncopenvpn.log
                else
                        echo -e "md5 check file not equal, start sync at `date`" >> /var/log/syncopenvpn.log
                fi
                echo "$md5" > md5check.txt
        else
                if [ ! -f /var/log/syncopenvpn.log ]; then
                        touch /var/log/syncopenvpn.log
                        echo -e "An error occurred, the administrator should check the problem at `date`" >> /var/log/syncopenvpn.log
                else
                        echo -e "An error occurred, the administrator should check the problem at `date`" >> /var/log/syncopenvpn.log
                fi
        fi
fi


