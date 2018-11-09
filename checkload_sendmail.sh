#/bin/bash
#Script check load and sendmail
#Author: tritran
### describe: Script will check load, if load average > 10 will execute tasks You want.
### simultaneously script will send mail to your email.
#recommend: Should install package `ssmtp` to increase mail reputation to inbox

load_avg=`cat /proc/loadavg | awk '{print $1}'`
#echo "$load_avg"
int=${load_avg%.*}
#echo "$int"

if [ $int -ge 10 ] ; then
	echo "load average currently: $load_avg"
	chattr -i /etc/nginx/protectlayer7.conf
	sed -i 's/testcookie off/testcookie on/g' /etc/nginx/protectlayer7.conf
	chattr -i /etc/nginx/protectlayer7.conf
	/etc/init.d/nginx restart >/dev/null 2>&1
	/etc/init.d/httpd restart >/dev/null 2>&1
	/etc/init.d/mysqld restart >/dev/null 2>&1	
	echo -e "High Load: `uptime` at `date` \nNhan duoc email nay, hay kiem tra VPS va tat testcookie" | mail -s "Warning Load High on `hostname`! Check It" -r  xxx@gmail.com yyy@gmail.com zzz@gmail.com
	echo -e "VPS check at `uptime`" >> /var/log/checkload.log
	echo "sendmail complete!"
	exit 0

else
	#echo "VPS nomally!!!"
	#echo "load average currently: $load_avg"
	exit 1
fi
