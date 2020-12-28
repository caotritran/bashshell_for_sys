#!/bin/bash
#Delete object old than 3 days

delete_object(){
	_date=`date +"%Y-%m-%d"`
	cur_time=`date -d $_date "+%s"` ## Epoch time

	echo "$1"
	oldtime=$(($cur_time-259200)) ### 60*60*24*3 days (convert to seconds)

	s3cmd ls s3://tn001/$1/ | awk '{print $1 " " $4}' > check.txt
	file="check.txt" ## Format as: 2020-10-31 s3://prefix_name/XXXXXXXXXXXXXXXXXXXXX/YYYYYYYYYYYYYYYYYYYYYY.jpg
	while IFS= read -r line
	do
		time_check=`echo "$line" | awk '{print $1}'`
		file_name=`echo "$line" | awk '{print $2}'`
		old_time=`date -d "$time_check" "+%s"`
		if [[ $old_time -le $oldtime ]]; then
			s3cmd rm $file_name
			#s3cmd ls s3://tn001/$1/$file_name
			echo "deleted file $file_name with time $time_check"
			echo "---"
		fi
	done < "$file"
}


file="list_device.txt"
while IFS= read -r line
do
	delete_object $line
done < "$file"
