#!/bin/bash
#Author: tritran

PS3="Ban Vui Lua Chon Chuc Nang De Su Dung Nhe!"
options=("Echo IP Public" "Print Ramdom Password" "Quit")

echo_IP_Public()
{
	IP=`dig +short myip.opendns.com @resolver1.opendns.com`
	echo "IP Public la: " $IP
}

print_Random_Password()
{
	rand_pass=`head /dev/urandom | tr -dc A-Za-z0-9 | head -c 13 ; echo ''`
	echo "Password Ramdom Cho Ban: " $rand_pass
}

select opt in "${options[@]}"
do
	case $opt in
		"Echo IP Public")
			echo_IP_Public
			break
			;;
		"Print Ramdom Password")
			print_Random_Password
			break
			;;
		"Quit")
			break
			;;
		*) echo "invalid option"
		esac
done
