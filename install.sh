#!/bin/bash
#Make by nahamsec Edit by @0xElkomy
sudo apt-get -y update
sudo apt-get -y upgrade


sudo apt-get install -y libcurl4-openssl-dev
sudo apt-get install -y libssl-dev
sudo apt-get install -y jq
apt-get install python-requests
apt-get install python-dnspython
apt-get install python-argparse
sudo apt-get install -y ruby-full
sudo apt-get install -y libcurl4-openssl-dev libxml2 libxml2-dev libxslt1-dev ruby-dev build-essential libgmp-dev zlib1g-dev
sudo apt-get install -y build-essential libssl-dev libffi-dev python-dev
sudo apt-get install -y python-setuptools
sudo apt-get install -y libldns-dev
sudo apt-get install -y python3-pip
sudo apt-get install -y python-pip
sudo apt-get install -y python-dnspython
sudo apt-get install -y git
sudo apt-get install -y rename
sudo apt-get install egrep
sudo apt-get install snap
sudo apt-get install snapd
sudo apt-get install -y xargs
sudo snap install amass
sudo apt-get install cargo

#pip / pip3 install
pip3 install Pool
pip3 install requests
pip3 install codecs
pip3 install time

#install go
if [[ -z "$GOPATH" ]];then
echo "It looks like go language is not installed, would you like to install it now"
PS3="Please select an option : "
choices=("yes" "no")
select choice in "${choices[@]}"; do
        case $choice in
                yes)

					echo "Installing Golang"
					wget https://go.dev/dl/go1.17.6.linux-amd64.tar.gz
					sudo tar -xvf go1.15.linux-amd64.tar.gz
					sudo mv go /usr/local
					export GOROOT=/usr/local/go
					export GOPATH=$HOME/go
					export PATH=$GOPATH/bin:$GOROOT/bin:$PATH
					echo 'export GOROOT=/usr/local/go' >> ~/.bashrc
					echo 'export GOPATH=$HOME/go'	>> ~/.bashrc		
					echo 'export PATH=$GOPATH/bin:$GOROOT/bin:$PATH' >> ~/.bashrc
					source ~/.bashrc
					sleep 1
					break
					;;
				no)
					echo "Please install go and rerun this script"
					echo "Aborting installation..."
					exit 1
					;;
	esac	
done
fi


#Don't forget to set up AWS credentials!
echo -e "Don't forget to set up AWS credentials!"
apt install -y awscli
echo -e "Don't forget to set up AWS credentials!"



#create a tools folder in ~/
mkdir ~/tools
cd ~/tools/

#Install shuffledns
echo -e "Installing shuffledns"
go install github.com/projectdiscovery/shuffledns/cmd/shuffledns@latest
echo -e "Done install shuffledns"

#install censys-subdomain-finder
echo -e "Installing censys-subdomain-finder"
git clone https://github.com/christophetd/censys-subdomain-finder.git
cd ~/tools/
cd censys-subdomain-finder
pip install -r requirements.txt
echo -e "Done install censys-subdomain-finder"

#install subfinder
echo -e "Installing subfinder"
cd ~/tools/
go install github.com/projectdiscovery/subfinder/cmd/subfinder@latest
echo -e "Done install subfinder"

#Install findomain
echo -e "Installing findomain"
git clone https://github.com/Edu4rdSHL/findomain.git -b develop
cd ~/tools/
cd findomain
cargo build --release
cp findomain /usr/bin/
echo -e "Done install findomain"

#SubDomainizer 
echo -e "Installing SubDomainizer"
cd ~/tools/
git clone https://github.com/nsonaniya2010/SubDomainizer.git
cd SubDomainizer
pip3 install -r requirements.txt
echo -e "Done Install SubDomainizer"


#CTFR  
echo -e "Installing CTFR"
cd ~/tools/
git clone https://github.com/UnaPibaGeek/ctfr.git
cd ctfr
pip3 install -r requirements.txt
echo -e "Done Install ctfr"


#TitleXtractor
cd ~/tools/
echo -e "Installing TitleXtractor"
go install github.com/dellalibera/titlextractor@latest
echo -e "Done Install TitleXtractor"

#Subdomain Takeover Scan via subzy
cd ~/tools/
echo -e "Installing Subzy"
go install github.com/lukasikic/subzy@latest
echo -e "Done Install Subzy"

#dnsprobe
echo -e "Installing dnsprobe"
cd ~/tools/
go install github.com/projectdiscovery/dnsprobe@latest
echo -e "Done Install dnsprobe"

#nuclei
echo -e "Installing nuclei"
cd ~/tools/
go install -v github.com/projectdiscovery/nuclei/v2/cmd/nuclei@latest
echo -e "Done Install nuclei"

#cookieless
echo -e "Installing cookieless"
cd ~/tools/
go install github.com/RealLinkers/cookieless@latest
echo -e "Done Install cookieless"

#XSStrike
echo -e "Installing XSStrike"
cd ~/tools/
git clone https://github.com/s0md3v/XSStrike
cd XSStrike
pip3 install -r requirements.txt
echo -e "Done Install XSStrike"

echo -e "Installing hakrawler"
cd ~/tools/
go install github.com/hakluke/hakrawler@latest
echo -e "Done Install hakrawler"

echo -e "Installing waybackurls"
cd ~/tools/
go install github.com/tomnomnom/waybackurls@latest
echo -e "Done Install waybackurls"

echo -e "Installing qsreplace"
cd ~/tools/
go install github.com/tomnomnom/qsreplace@latest
echo -e "Done Install qsreplace"

echo -e "Installing gau"
cd ~/tools/
go install -v github.com/lc/gau@latest
echo -e "Done Install gau"

#CMSmap Vulnerabilities Scanning WordPress, Joomla, Drupal and Moodle
echo -e "Installing CMSmap"
cd ~/tools/
git clone https://github.com/Dionach/CMSmap.git
cd CMSmap
pip3 install .
echo -e "Done Install CMSmap"

#Testing for Default HTTP Login.
echo -e "Installing default-http-login-hunter"
cd ~/tools/
git clone https://github.com/InfosecMatter/default-http-login-hunter
echo -e "Done Install default-http-login-hunter"

echo -e "Installing Workflow-Bug-Bounty xElkomy"
cd ~/tools/
git clone https://github.com/xElkomy/Workflow-Bug-Bounty
echo -e "Done Install Workflow-Bug-Bounty xElkomy"

echo -e "Installing KXSS"
cd ~/tools/
go install github.com/tomnomnom/hacks/kxss@latest
echo -e "Done Install KXSS"

#install aquatone
echo "Installing Aquatone"
cd ~/tools/
go install github.com/michenriksen/aquatone@latest
echo -e "Done Install Aquatone"

#install chromium
echo -e "Installing Chromium"
sudo snap install chromium
echo -e "Done install chromium"

echo -e "installing JSParser"
git clone https://github.com/nahamsec/JSParser.git
cd JSParser*
sudo python setup.py install
cd ~/tools/
echo -e "Done install JSParser"

echo -e "installing Sublist3r"
git clone https://github.com/aboul3la/Sublist3r.git
cd Sublist3r*
pip install -r requirements.txt
cd ~/tools/
echo -e "Done install Sublist3r"


echo -e "installing teh_s3_bucketeers"
git clone https://github.com/tomdev/teh_s3_bucketeers.git
cd ~/tools/
echo -e "Done install teh_s3_bucketeers"


echo -e "installing wpscan"
git clone https://github.com/wpscanteam/wpscan.git
cd wpscan*
sudo gem install bundler && bundle install --without test
cd ~/tools/
echo -e "Done install wpscan"

echo -e "installing dirsearch"
git clone https://github.com/maurosoria/dirsearch.git
cd ~/tools/
echo -e "Done install dirsearch"

echo -e "installing sqlmap"
git clone --depth 1 https://github.com/sqlmapproject/sqlmap.git sqlmap-dev
cd ~/tools/
echo -e "Done install sqlmap"

echo -e "installing knock.py"
git clone https://github.com/guelfoweb/knock.git
cd ~/tools/
echo -e "Done install knock.py"

echo -e "installing nmap"
sudo apt-get install -y nmap
echo -e "Done install nmap"

echo -e "installing massdns"
git clone https://github.com/blechschmidt/massdns.git
cd ~/tools/massdns
make
cd ~/tools/
echo -e "Done install massdns"

echo -e "installing asnlookup"
git clone https://github.com/yassineaboukir/asnlookup.git
cd ~/tools/asnlookup
pip install -r requirements.txt
cd ~/tools/
echo -e "Done install asnlookup"

echo -e "installing httprobe"
go install github.com/tomnomnom/httprobe@latest
echo -e "Done install httprobe"

echo -e "installing unfurl"
go install github.com/tomnomnom/unfurl@latest
echo -e "Done install unfurl"

echo -e "installing Web-Cache-Vulnerability-Scanner"
go install https://github.com/Hackmanit/Web-Cache-Vulnerability-Scanner
echo -e "Done install Web-Cache-Vulnerability-Scanner"

echo -e "installing crtndstry"
git clone https://github.com/nahamsec/crtndstry.git
echo -e "Done install crtndstry"

echo -e "downloading Seclists"
cd ~/tools/
git clone https://github.com/danielmiessler/SecLists.git
cd ~/tools/SecLists/Discovery/DNS/
##THIS FILE BREAKS MASSDNS AND NEEDS TO BE CLEANED
cat dns-Jhaddix.txt | head -n -14 > clean-jhaddix-dns.txt
cd ~/tools/
echo -e "Done install SecLists"

echo -e "installing httpx"
go install github.com/projectdiscovery/httpx@latest
cd ~/tools/
echo -e "Done install httpx"

echo -e "installing aem-hacker"
git clone https://github.com/0ang3el/aem-hacker.git
cd ~/tools/
echo -e "Done install aem-hacker"

echo -e "installing Goohak"
git clone https://github.com/1N3/Goohak.git
cd ~/tools/
echo -e "Done install Goohak"

echo -e "installing jexboss"
git clone https://github.com/joaomatosf/jexboss.git ~/tools/jexboss
cd ~/tools/jexboss
pip3 install -r requires.txt
cd ~/tools/
echo -e "Done install jexboss"

echo -e "installing scant3r"
git clone https://github.com/knassar702/scant3r ~/tools/scant3r
cd ~/tools/scant3r
pip3 install -r requirements.txt
cd ~/tools/
echo -e "Done install scant3r"

echo -e "installing crlfuzz"
git clone https://github.com/dwisiswant0/crlfuzz.git ~/tools/crlfuzz
cd ~/tools/crlfuzz/cmd/crlfuzz
go build .
mv crlfuzz /usr/local/bin
cd ~/tools/
echo -e "Done install crlfuzz"

echo -e "installing lazys3"
git clone https://github.com/nahamsec/lazys3.git ~/tools/lazys3
cd ~/tools/
echo -e "Done install lazys3"

echo -e "installing flumberboozle"
git clone https://github.com/fellchase/flumberboozle.git ~/tools/flumberboozle
cd ~/tools/
echo -e "Done install flumberboozle"

echo -e "\n\n\n\n\n\n\n\n\n\n\nDone! All tools are set up in ~/tools"
ls -la
echo -e "One last time: don't forget to set up AWS credentials in ~/.aws/!"
