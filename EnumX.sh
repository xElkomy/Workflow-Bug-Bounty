#!/bin/bash

#xElkomy - Khaled Mohamed

#COLORS
BOLD="\e[1m"  
NORMAL="\e[0m"
GREEN="\e[92m"


echo -e "${GREEN}[+]Start Subdomain Enumeretion"

#Assetfinder
echo -e "${GREEN}[+] Starting Assetfinder"
assetfinder --subs-only $1 |sort -u |tee assetfinder.txt

#Sublist3r
echo -e "${GREEN}[+] Starting Sublist3r"
python ~/tools/Sublist3r/sublist3r.py -d $1 -o sublist3r.txt

#Filtering
echo -e "${GREEN}[+] Starting Filtering"
cat sublist3r.txt assetfinder.txt |grep -v "*" |sort -u |tee Final-Subs.txt

#Httprobe
echo -e "${GREEN}[+] Starting Httprobe"
cat Final-Subs.txt |sort -u |uniq -u|httprobe|tee $1-alive.txt

#Get-Tilie
echo -e "${GREEN}[+]Start Get-titles"
cat $1-alive.txt|get-titles

echo -e "${GREEN}[+]Start Subdomain Takeover Scan"
subjack -w Final-Subs.txt -t 20 -ssl -c ~/tools/fingerprints.json -v 3 -o subjack.txt
subzy -targets Final-Subs.txt -hide_fails --verify_ssl -concurrency 20 |sort -u|tee "subzy.txt"

echo -e "${GREEN}[+]Aquatone Screenshot"
cat $1-alive.txt| aquatone -screenshot-timeout 10 -out screenshots/

echo -e "${GREEN}[+]Finishing The Enumeration OR The Reconnaisses"

rm sublist3r.txt assetfinder.txt
