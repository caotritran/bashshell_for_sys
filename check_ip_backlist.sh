#/bin/sh
#Script check IP blacklist
#Author: tritran
#usage: ./script.sh IP
#example: ./checkbl.sh 11.22.33.44

check_lenght=$#
echo "$check_lenght"
if [ $check_lenght -ne 1 ]; then
	echo "Usage: ./script.sh IP"
fi

IP=$1
echo "IP is: $IP"

reverse_IP=$(echo $IP | awk -F. '{print $4"."$3"." $2"."$1}')
echo "reverse IP is: $reverse_IP"

check_blacklist(){
for i in ${Blacklist}; do
	printf "%-40s" "  ${reverse_IP}.$i."

	listed="$(dig +short -t a ${reverse_IP}.$i.)"

	#check neu bien $listed khong null
	if [ ! -z "$listed" ]; then
		echo "[blacklisted] $listed" | cecho LRED
	else
		echo "[not listed]" | cecho LGREEN
	fi
done
}

cecho(){
  LGREEN="\033[1;32m"
  LRED="\033[1;31m"
  YELLOW="\033[1;33m"
  NORMAL="\033[m"
 
  color=\$${1:-NORMAL}
 
  echo -ne "$(eval echo ${color})"
  cat
 
  echo -ne "${NORMAL}"
}

Blacklist="
bl.score.senderscore.com
bl.mailspike.net
bl.spameatingmonkey.net
b.barracudacentral.org
bl.deadbeef.com
bl.emailbasura.org
bl.spamcannibal.org
bl.spamcop.net
blackholes.five-ten-sg.com
blacklist.woody.ch
bogons.cymru.com
cbl.abuseat.org
cdl.anti-spam.org.cn
combined.abuse.ch
combined.rbl.msrbl.net
db.wpbl.info
dnsbl-1.uceprotect.net
dnsbl-2.uceprotect.net
dnsbl-3.uceprotect.net
dnsbl.ahbl.org
dnsbl.inps.de
dnsbl.sorbs.net
drone.abuse.ch
drone.abuse.ch
duinv.aupads.org
dul.dnsbl.sorbs.net
dul.ru
dyna.spamrats.com
dynip.rothen.com
http.dnsbl.sorbs.net
images.rbl.msrbl.net
ips.backscatterer.org
ix.dnsbl.manitu.net
korea.services.net
misc.dnsbl.sorbs.net
noptr.spamrats.com
ohps.dnsbl.net.au
omrs.dnsbl.net.au
orvedb.aupads.org
osps.dnsbl.net.au
osrs.dnsbl.net.au
owfs.dnsbl.net.au
owps.dnsbl.net.au
pbl.spamhaus.org
phishing.rbl.msrbl.net
probes.dnsbl.net.au
proxy.bl.gweep.ca
proxy.block.transip.nl
psbl.surriel.com
rbl.interserver.net
rdts.dnsbl.net.au
relays.bl.gweep.ca
relays.bl.kundenserver.de
relays.nether.net
residential.block.transip.nl
ricn.dnsbl.net.au
rmst.dnsbl.net.au
sbl.spamhaus.org
short.rbl.jp
smtp.dnsbl.sorbs.net
socks.dnsbl.sorbs.net
spam.abuse.ch
spam.dnsbl.sorbs.net
spam.rbl.msrbl.net
spam.spamrats.com
spamlist.or.kr
spamrbl.imp.ch
t3direct.dnsbl.net.au
tor.ahbl.org
tor.dnsbl.sectoor.de
torserver.tor.dnsbl.sectoor.de
ubl.lashback.com
ubl.unsubscore.com
virbl.bit.nl
virus.rbl.jp
virus.rbl.msrbl.net
web.dnsbl.sorbs.net
wormrbl.imp.ch
xbl.spamhaus.org
zen.spamhaus.org
zombie.dnsbl.sorbs.net
"

check_blacklist
