#!/bin/bash

[ -z "$1" ] && { printf "\n[!] Usage: bash EnumX.sh example.com\n"; exit; }

#COLORS
BOLD="\e[1m"
NORMAL="\e[0m"
GREEN="\e[92m"
#--------------------------------------------------------------------------------------------------------------------
echo -e "${GREEN}[+]Start Subdomain Enumeretion"
#--------------------------------------------------------------------------------------------------------------------

#Assetfinder
echo -e "${GREEN}[+] Starting Assetfinder"
#--------------------------------------------------------------------------------------------------------------------
assetfinder --subs-only $1 |sort -u |tee assetfinder.txt
#--------------------------------------------------------------------------------------------------------------------
echo -e "${GREEN}[+] Some Free Apis to extract the subdomains"
#--------------------------------------------------------------------------------------------------------------------
curl --silent "https://www.threatcrowd.org/searchApi/v2/domain/report/?domain=$1" | grep -o -E "[a-zA-Z0-9._-]+\.$1" > tmp.txt
curl --silent "https://api.hackertarget.com/hostsearch/?q=$1" | grep -o -E "[a-zA-Z0-9._-]+\.$1" >> tmp.txt
curl --silent "https://crt.sh/?q=%.$1" | grep -oP "\<TD\>\K.*\.$1" | sed -e 's/\<BR\>/\n/g' | grep -oP "\K.*\.$1" | sed -e 's/[\<|\>]//g' | grep -o -E "[a-zA-Z0-9._-]+\.$1"  >> tmp.txt
curl --silent "https://crt.sh/?q=%.%.$1" | grep -oP "\<TD\>\K.*\.$1" | sed -e 's/\<BR\>/\n/g' | sed -e 's/[\<|\>]//g' | grep -o -E "[a-zA-Z0-9._-]+\.$1" >> tmp.txt
curl --silent "https://crt.sh/?q=%.%.%.$1" | grep "$1" | cut -d '>' -f2 | cut -d '<' -f1 | grep -v " " | grep -o -E "[a-zA-Z0-9._-]+\.$1" | sort -u >> tmp.txt
curl --silent "https://crt.sh/?q=%.%.%.%.$1" | grep "$1" | cut -d '>' -f2 | cut -d '<' -f1 | grep -v " " | grep -o -E "[a-zA-Z0-9._-]+\.$1" |  sort -u >> tmp.txt
curl --silent "https://certspotter.com/api/v0/certs?domain=$1" | grep  -o '\[\".*\"\]' | sed -e 's/\[//g' | sed -e 's/\"//g' | sed -e 's/\]//g' | sed -e 's/\,/\n/g' | grep -o -E "[a-zA-Z0-9._-]+\.$1" >> tmp.txt
curl --silent "https://spyse.2com/target/domain/$1" | grep -E -o "button.*>.*\.$1\/button>" |  grep -o -E "[a-zA-Z0-9._-]+\.$1" >> tmp.txt
curl --silent "https://tls.bufferover.run/dns?q=$1" | grep -o -E "[a-zA-Z0-9._-]+\.$1" >> tmp.txt
curl --silent "https://dns.bufferover.run/dns?q=.$1" | grep -o -E "[a-zA-Z0-9._-]+\.$1" >> tmp.txt
curl --silent "https://urlscan.io/api/v1/search/?q=$1" | grep -o -E "[a-zA-Z0-9._-]+\.$1" >> tmp.txt
curl --silent -X POST "https://synapsint.com/report.php" -d "name=http%3A%2F%2F$1" | grep -o -E "[a-zA-Z0-9._-]+\.$1" >> tmp.txt
curl --silent "https://jldc.me/anubis/subdomains/$1" | grep -Po "((http|https):\/\/)?(([\w.-]*)\.([\w]*)\.([A-z]))\w+" >> tmp.txt
curl --silent "https://sonar.omnisint.io/subdomains/$1" | grep -o -E "[a-zA-Z0-9._-]+\.$1" >> tmp.txt
curl --silent "https://otx.alienvault.com/api/v1/indicators/domain/$1/passive_dns" | grep -o -E "[a-zA-Z0-9._-]+\.$1" >> tmp.txt
curl --silent "https://riddler.io/search/exportcsv?q=pld:$1" | grep -o -E "[a-zA-Z0-9._-]+\.$1" >> tmp.txt
#--------------------------------------------------------------------------------------------------------------------
cat tmp.txt | sed -e "s/\*\.$1//g" | sed -e "s/^\..*//g" | grep -o -E "[a-zA-Z0-9._-]+\.$1" | sort -u | allapis.txt
#--------------------------------------------------------------------------------------------------------------------
#Sublist3r
echo -e "${GREEN}[+] Starting Sublist3r"
#--------------------------------------------------------------------------------------------------------------------
python ~/tools/Sublist3r/sublist3r.py -d $1 -o sublist3r.txt
#--------------------------------------------------------------------------------------------------------------------
#Subfinder
#go get -v github.com/projectdiscovery/subfinder/cmd/subfinder
echo -e "${GREEN}[+] Starting Subfinder "
#--------------------------------------------------------------------------------------------------------------------
subfinder -d  $1 |sort -u |tee subfinder.txt
#--------------------------------------------------------------------------------------------------------------------
#Amass
echo -e "${GREEN}[+] Starting Amass\n"
#--------------------------------------------------------------------------------------------------------------------
amass enum -d $1 --passive -o amass.txt
#--------------------------------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------------------------------
#Filtering
echo -e "${GREEN}[+] Starting Filtering\n"
#--------------------------------------------------------------------------------------------------------------------
cat sublist3r.txt assetfinder.txt subfinder.txt allapis.txt| sort -u |uniq -u| grep -v "*" |sort -u|tee Final-Subs.txt
#--------------------------------------------------------------------------------------------------------------------
#Httprobe
echo -e "${GREEN}[+] Starting Httpx\n"
#--------------------------------------------------------------------------------------------------------------------
cat Final-Subs.txt |sort -u |uniq -u|httpx -silent |tee $1-alive.txt
#--------------------------------------------------------------------------------------------------------------------
echo -e "${GREEN}[+]Start Subdomain Takeover Scan\n"
#--------------------------------------------------------------------------------------------------------------------
subzy -targets Final-Subs.txt -hide_fails --verify_ssl -concurrency 20 |sort -u|tee "subzy.txt"
#--------------------------------------------------------------------------------------------------------------------
echo -e "${GREEN}[+] DNSPROBE Start\n"
#--------------------------------------------------------------------------------------------------------------------
cat $1-alive.txt|dnsprobe -o $1-dnsprobe.txt
#--------------------------------------------------------------------------------------------------------------------
echo -e "${GREEN}[+]Finishing The Enumeration OR The Reconaisses\n"
#--------------------------------------------------------------------------------------------------------------------
rm sublist3r.txt assetfinder.txt subfinder.txt allapis.txt tmp.txt
#--------------------------------------------------------------------------------------------------------------------
