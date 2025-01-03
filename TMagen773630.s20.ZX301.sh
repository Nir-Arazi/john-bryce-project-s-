#!/bin/bash

path=$(pwd)

# Here I'm unzipping and deleting the zip file for statistics
unzip hunt_db.zip > /dev/null 2>&1
rm -r hunt_db.zip > /dev/null 2>&1

# This is the goodbye function :)
goodbye() {
clear
echo " ▬▬▬.◙.▬▬▬"
echo " ═▂▄▄▓▄▄▂"
echo " ◢◤ █▀▀████▄▄▄◢◤"
echo " █▄ █ █▄ ███▀▀▀▀▀▀╬"
echo " ◥█████◤"
echo " ══╩══╩═"
echo " ╬═╬"
echo " ╬═╬"
echo " ╬═╬    Just dropped down to say"
echo " ╬═╬    thank you for using the exploit hunt! "
echo " ╬═╬"
echo " ╬═╬ ☻/"
echo " ╬═╬/▌"
echo " ╬═╬/ \\"
}

# Here the user will have the option to zip the database
file_zip() {
cd $path
echo -e " "${purple}" [?] Would you like to zip all the databases? [y,N]  "${reset}"  "
read -p "  [?] " zip
if [[ $zip == y ]] ; then
zip -r hunt_db.zip hunt_db > /dev/null 2>&1
echo -e " "${green}" [+] Zipping hunt_db "${reset}" "
rm -r hunt_db
sleep 2
goodbye
else
goodbye
fi
}

# Here the user will be given the choice to see all the results
results() {
echo -e " "${purple}" [?] Would you like to see what we found so far? "${reset}" "
read  -p "  [?] (y,N) "  results
if [[ $results == y ]] ; then
for i in $(ls)
do
echo -e " "${green}" $i  "${reset}"  "
done
file_zip
else
echo -e " "${green}" [+] You could see all the results here $(pwd) "${reset}" "
file_zip
exit
fi
}

# Root checking and the cool ASCII art
root_check() {
root=$(whoami)
if [[ "$root" == root ]]; then 
purple="\033[0;35m"
yellow='\033[0;33m'
white='\033[1;37m'     # White for sails
blue='\033[0;34m'      # Blue for waves
red='\033[1;31m '     # Red for message
reset='\033[0m' # Reset to default terminal colors
black="\033[0;30m"
green="\033[0;32m"
echo -e "${white}"
echo "                               |    |    |                                "
echo "                              )_)  )_)  )_)                               "
echo "                             )___))___))___)\\                            "
echo "                            )____)____)_____)\\\\                          "
echo -e " "${white}"                      _____|____|____|____|___\\\\\\\\\\__________               "
echo "              ________/                                     \\______       "
echo -e "              \\         "${red}"  ~~~ Exploits Ahead! ~~~   "${white}"          /          "
echo "               \\_____________________________________________/           "
echo -e " ${blue}            ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~         "
echo "       ~~~~~~~~~~~~~~~~    ~~~~~~~~~~~~~~~~    ~~~~~~~~~~~~~~~~            "
echo "                   ~~~~~~~~         ~~~~~~~~        ~~~~~~~~~~             "
echo "                          ~~~~~~~~~       ~~~~~~~~~~~~~~~~                 "
echo "                               ~~~~~~~~~~~~~~~~                            "
echo -e " ${reset} "

printf " ${reset} "

# Acknowledgment to the user and directory creation
echo -e ""${green}"[+] Hello and welcome to the exploit hunt [+] "${reset}" "
echo
echo -e " "${yellow}" [!] Creating a main directory named hunt_db [!] "${reset}" "
mkdir -m 777 hunt_db > /dev/null 2>&1
cd hunt_db
echo

else
echo -e " "${red}"[-] Please use the root user or sudo "${reset}"  "
exit
fi
}
root_check

# Tools installation
tools_check() {
echo -e " "${yellow}" [!] Checking that all the tools are installed "${reset}" "
if command -v nmap > /dev/null ; then 
echo -e " "${green}" [+] Nmap installed  "${reset}" "
else
echo -e " "${red}"[-] Nmap not installed, installing...  "${reset}" "
sudo apt install nmap -y > /dev/null 2>&1
fi
sleep 4
echo
if command -v masscan > /dev/null ; then 
echo -e " "${green}" [+] Masscan installed  "${reset}" "
else
echo -e " "${red}"[-] Masscan not installed, installing...  "${reset}" "
sudo apt install masscan -y > /dev/null 2>&1
fi
sleep 4
echo
if command -v searchsploit > /dev/null ; then 
echo -e " "${green}" [+] Searchsploit installed  "${reset}" "
else
echo -e " "${red}"[-] Searchsploit not installed, installing...  "${reset}" "
sudo apt install searchsploit -y > /dev/null 2>&1
fi
sleep 4
echo
if command -v hydra > /dev/null ; then 
echo -e " "${green}" [+] Hydra installed  "${reset}" "
else
echo -e " "${red}"[-] Hydra not installed, installing...  "${reset}" "
sudo apt install hydra -y > /dev/null 2>&1
fi
sleep 4
echo
if command -v seclists > /dev/null ; then
echo -e " "${green}" [+] seclists  installed   "${reset}" "
else
echo -e " "${red}"[-] seclists  not installed, installing...  "${reset}" "
sudo apt install seclists -y  > /dev/null 2>&1
fi
sleep 4
}
tools_check

echo 
# This is the brute force function / after the scanning phase is completed 
brute_forcing(){
echo -e " "${green}" [+] Scan completed "${reset}" "

# Here the user has the choice to test for weak passwords
echo -e " "${purple}" [?] Would you like to test for weak passwords [y,N] "${reset} ""
read -p '  [?]'  PASS
if [[ $PASS == y ]] ; then 
echo -e  " "${yellow}" [!] Would you like to use the built-in password list or use your own "${reset}" "
echo -e " "${blue}" 
  [1] I'm lazy, I will use the built-in word list

  [2] I came prepared 
"${reset}"
"
else 
results
exit
fi
read -p '  [?] ' brute_LIST

		case $brute_LIST in
		# Here the user selected the lazy route so they can enjoy some built-in passwords
		1)
		echo -e "  "${green}"[+] You chose the lazy route "${reset}"  "
		echo
		# This is the best IP variable, it will let the user know which IP has the most ports
		best_ip=$(ls -l | sort -nr | head -2 | awk '{print $9}' |  tr -d " nmap_scan_ ")
		brute_ip=$best_ip
		echo -e " "${green}" [+] The most suitable IP is: "$best_ip" "${reset}" "
		echo
		echo -e " "${yellow}" [!] Would you like to start the brute force on this IP or all the IPs "${reset}" "
		echo -e " ${blue}" " 
  [1] Brute force "$best_ip"

  [2] All the IPs 
		"${reset} " "
		read -p '  [?]' brute
		case $brute in
		1)
		# Brute forcing the best IP 
		
		for i in $(ls -l | sort -nr | head -2 | awk '{print $9}' |  tr -d " nmap_scan_ ")
		do
		echo -e " "${yellow}" [!] Checking weak passwords in ssh " ${reset} " "
		hydra -L /usr/share/seclists/Usernames/top-usernames-shortlist.txt -P /usr/share/dirb/wordlists/common.txt  ssh://"$i" >> ssh_.pass_$i   2>/dev/null
		echo
		echo -e " "${yellow}" [!] Checking weak passwords in telnet " ${reset} " "
		hydra -L /usr/share/seclists/Usernames/top-usernames-shortlist.txt -P /usr/share/dirb/wordlists/common.txt  telnet://"$i" >> telnet.pass_$i   2>/dev/null
		echo
		echo -e " "${yellow}" [!] Checking weak passwords in rdp " ${reset} " "
		hydra -L /usr/share/seclists/Usernames/top-usernames-shortlist.txt -P /usr/share/dirb/wordlists/common.txt  rdp://"i"  >> rdp.pass_$i 2>/dev/null
		echo
		echo -e " "${yellow}" [!] Checking weak passwords in ftp " ${reset} " "
		hydra -L /usr/share/seclists/Usernames/top-usernames-shortlist.txt -P /usr/share/dirb/wordlists/common.txt  ftp "i"  >> ftp.pass_$i 2>/dev/null
		done
		results
		exit
		;;
		2)
		# Brute forcing all the IPs
		list_check() {
		# Looping all the valid IPs
		for i in $(cat .host_up | grep for | awk '{print $5}' | grep '^[0-9]' )
		do 
		echo -e " "${yellow}" [!] Checking weak passwords in ssh " ${reset} " "
        hydra -L /usr/share/seclists/Usernames/top-usernames-shortlist.txt -P /usr/share/dirb/wordlists/common.txt  ssh://"$i" >> ssh_.pass_$i   2>/dev/null
		credentials_check=$(cat ssh_.pass_$i | grep -w login:) 2>/dev/null
		if [[ -z $credentials_check ]] ; then 
		echo -e " "${red}"[-] Credentials weren't found for ssh $i "${reset}"  "
		rm ssh_.pass_$i > /dev/null 2>&1
		sleep 7
		clear
		else 
		echo -e " "${green}" [+] Found credentials for ssh $i " ${reset} "  "
		sleep 7
		clear
		fi
		echo -e " "${yellow}" [!] Checking weak passwords in telnet " ${reset} " "
		hydra -L /usr/share/seclists/Usernames/top-usernames-shortlist.txt -P /usr/share/dirb/wordlists/common.txt  telnet://"$i" >> telnet.pass_$i   2>/dev/null
		credentials_check=$(cat telnet.pass_$i | grep -w login:)
		if [[ -z $credentials_check ]] ; then 
		echo -e " "${red}"[-] Credentials weren't found for telnet  $i "${reset}" "
		rm telnet.pass_$i > /dev/null 2>&1
		sleep 7
		clear
		else 
		echo -e " "${green}" [+] Found credentials for telnet $i  "${reset}" "
		sleep 7
		clear
		fi
		echo
		echo -e " "${yellow}" [!] Checking weak passwords in rdp "${reset}" "
		hydra -L /usr/share/seclists/Usernames/top-usernames-shortlist.txt -P /usr/share/dirb/wordlists/common.txt  rdp://"i"  >> rdp.pass_$i 2>/dev/null
			credentials_check=$(cat rdp.pass_$i | grep -w login:)
		if [[ -z $credentials_check ]] ; then 
		echo -e " "${red}"[-] Credentials weren't found for rdp  $i  "${reset}" "
		rm rdp.pass_$i > /dev/null 2>&1
		sleep 7
		clear
		else 
		echo -e " "${green}" [+] Found credentials for rdp $i "${reset}" "
		sleep 7
		clear
		fi
		
		echo
echo -e " "${yellow}" [!] Checking weak passwords in ftp "${reset}" "
hydra -L /usr/share/seclists/Usernames/top-usernames-shortlist.txt -P /usr/share/dirb/wordlists/common.txt  ftp "i"  >> ftp.pass_$i 2>/dev/null
credentials_check=$(cat ftp.pass_$i | grep -w login:)
if [[ -z $credentials_check ]] ; then 
    echo -e " "${red}"[-] Credentials weren't found for ftp $i  "${reset}" "
    rm ftp.pass_$i > /dev/null 2>&1
    sleep 7
    clear
else 
    echo -e " "${green}" [+] Found credentials for ftp $i "${reset}" "
    sleep 7
    clear
fi
done
}
list_check
esac
;;
2)
# This is the best IP variable; it will let the user know which IP has the most ports
best_ip=$(ls -l | sort -nr | head -2 | awk '{print $9}' |  tr -d " nmap_scan_ ")
brute_ip=$best_ip
echo -e " "${green}" [+] The most suitable IP is: "$best_ip" "${reset}" "
echo
echo -e " "${yellow}" [!] Would you like to start the brute force on this IP or all the IPs "${reset}" "
		echo -e " ${blue}" " 
  [1] Brute force "$best_ip"

  [2] All the IPs
		"${reset} " "
		read -p '  [?]' brute
case $brute in
1)
list_check-1(){
word_listt(){
echo -e " "${yellow}" [!] Please insert a {word list} and {password list} " ${reset} " "
read -p "  [?] word_list " word_list
if [[ -s "$path/$word_list" ]] ; then
    echo -e " "${green}" [+] Word list set " ${reset} " "
else
    echo -e " "${red}"[-] Word list doesn't exist " ${reset} " "
    echo -e " "${yellow}" [!] Restarting " ${reset} " "
    word_listt
fi
}
pass_listt(){
read -p "  [?] pass_list " pass_list
if [[ -s "$path/$pass_list" ]] ; then
    echo -e " "${green}" [+] Password list set " ${reset} " "    
    for i in $(ls -l | sort -nr | head -2 | awk '{print $9}' |  tr -d " nmap_scan_ ")
    do
    echo -e " "${yellow}" [!] Checking weak passwords in ssh " ${reset} " "
    hydra -L "$path/$word_list" -P "$path/$pass_list" ssh://"$i" >> ssh.pass_$i   2>/dev/null
    credentials_check=$(cat ssh.pass_$i | grep -w login: ) 2>/dev/null
    if [[ -z $credentials_check ]] ; then 
        echo -e " "${red}"[-] Credentials weren't found for ssh $i "${reset}"  "
        rm ssh_pass_$i > /dev/null 2>&1
        sleep 7
        clear
    else 
        echo -e " "${green}" [+] Found credentials for ssh $i " ${reset} "  "
        sleep 7
        clear
    fi
    echo
    echo -e " "${yellow}" [!] Checking weak passwords in telnet " ${reset} " "
    hydra -L "$path/$word_list" -P "$path/$pass_list" telnet://"$i" >> telnet.pass_$i    2>/dev/null
    credentials_check=$(cat  telnet.pass_$i | grep -w login:)
    if [[ -z $credentials_check ]] ; then 
        echo -e " "${red}"[-] Credentials weren't found for telnet $i "${reset}"  "
        rm telnet.pass_$i > /dev/null 2>&1
        sleep 7
        clear
    else 
        echo -e " "${green}" [+] Found credentials for telnet $i " ${reset} "  "
        sleep 7
        clear
    fi
    echo
    echo -e " "${yellow}" [!] Checking weak passwords in rdp " ${reset} " "
    hydra -L "$path/$word_list" -P "$path/$pass_list"  rdp://"$i"  >> rdp.pass_$i 2>/dev/null
    credentials_check=$(cat rdp.pass_$i | grep -w login:)
    if [[ -z $credentials_check ]] ; then 
        echo -e " "${red}"[-] Credentials weren't found for rdp $i "${reset}"  "
        rm rdp.pass_$i > /dev/null 2>&1
        sleep 7
        clear
    else 
        echo -e " "${green}" [+] Found credentials for rdp $i " ${reset} "  "
        sleep 7
        clear
    fi
    echo
    echo -e " "${yellow}" [!] Checking weak passwords in ftp " ${reset} " "
    hydra -L "$path/$word_list" -P "$path/$pass_list" ftp:// "$i"  >> ftp.pass_$i 2>/dev/null
   credentials_check=$(cat ftp.pass_$i | grep -w login:)
    if [[ -z $credentials_check ]] ; then 
        echo -e " "${red}"[-] Credentials weren't found for ftp $i "${reset}"  "
        rm ftp.pass_$i  > /dev/null 2>&1
        sleep 7
        clear
    else 
        echo -e " "${green}" [+] Found credentials for ftp $i " ${reset} "  "
        sleep 7
        clear
    fi
    done
    results
    exit
else
    echo -e " "${red}"[-] Password list doesn't exist "${reset}" "
    echo -e " "${yellow}" [!] Restarting  "${reset}" "
pass_listt
fi
}
word_listt
pass_listt
}
list_check-1
;;
2)
# Asking the user for password and user
list_check() {
echo -e " "${yellow}" [!] Please insert a {word list} and {password list} " ${reset} " "
read -p "  [?] word_list " word_list
if [[ -s "$path/$word_list" ]] ; then
    echo -e " "${green}" [+] Word list set " ${reset} " "
else
    echo -e " "${red}" [-] Word list doesn't exist " ${reset} " "
    echo -e " "${yellow}" [!] Restarting " ${reset} " "
    list_check
fi
read -p "  [?] pass_list " pass_list
if [[ -s "$path/$pass_list" ]] ; then
    echo -e " "${green}" [+] Password list set " ${reset} " "
    # Looping all the valid IPs / checking for cracked passwords
    for i in $(cat .host_up | grep for | awk '{print $5}' | grep '^[0-9]' )
    do 
    echo -e " "${yellow}" [!] Checking weak passwords in ssh " ${reset} " "
    hydra -L "$path/$word_list" -P "$path/$pass_list" ssh://"$i" >> ssh_.pass_$i   2>/dev/null
        credentials_check=$(cat ssh.pass_$i | grep -w login: ) 2>/dev/null
    if [[ -z $credentials_check ]] ; then 
        echo -e " "${red}"[-] Credentials weren't found for ssh $i "${reset}"  "
        rm ssh_.pass_$i
        sleep 7
        clear
    else 
        echo -e " "${green}" [+] Found credentials for ssh $i " ${reset} "  "
        sleep 7
        clear
    fi
    echo
    echo -e " "${yellow}" [!] Checking weak passwords in telnet " ${reset} " "
    hydra -L "$path/$word_list" -P "$path/$pass_list" telnet://"$i" >> telnet.pass_$i   2>/dev/null
    credentials_check=$(cat  telnet.pass_$i | grep -w login:)
    if [[ -z $credentials_check ]] ; then 
        echo -e " "${red}"[-] Credentials weren't found for telnet $i "${reset}"  "
        rm telnet.pass_$i
        sleep 7
        clear
    else 
        echo -e " "${green}" [+] Found credentials for telnet $i " ${reset} "  "
        sleep 7
        clear
    fi
    echo
    echo -e " "${yellow}" [!] Checking weak passwords in rdp " ${reset} " "
    hydra -L "$path/$word_list" -P "$path/$pass_list"  rdp://"$i"  >> rdp.pass_$i 2>/dev/null
        credentials_check=$(cat rdp.pass_$i | grep -w login:)
    if [[ -z $credentials_check ]] ; then 
        echo -e " "${red}"[-] Credentials weren't found for rdp $i "${reset}"  "
        rm rdp.pass_$i
        sleep 7
        clear
    else 
        echo -e " "${green}" [+] Found credentials for rdp $i " ${reset} "  "
        sleep 7
        clear
    fi
    echo
    echo -e " "${yellow}" [!] Checking weak passwords in ftp " ${reset} " "
    hydra -L "$path/$word_list" -P "$path/$pass_list" ftp:// "$i"  >> ftp.pass_$i 2>/dev/null
    credentials_check=$(cat ftp.pass_$i | grep -w login:)
    if [[ -z $credentials_check ]] ; then 
        echo -e " "${red}"[-] Credentials weren't found for ftp $i "${reset}"  "
        rm ftp.pass_$i
        sleep 7
        clear
    else 
        echo -e " "${green}" [+] Found credentials for ftp $i " ${reset} "  "
        sleep 7
        clear
    fi
    done
    results
    exit
else
    echo -e " "${red}" [-] Password list doesn't exist "${reset}" "
    echo -e " "${yellow}" [!] Restarting  "${reset}" "
    list_check
fi
}
list_check
esac
esac
rm .valid_ip
}

Basic_scan() {
mkdir Basic_scan > /dev/null 2>&1
mv ./.valid_ip ./Basic_scan > /dev/null 2>&1
mv ./$DIR ./Basic_scan > /dev/null 2>&1
cd Basic_scan
echo -e " "${green}" [+] Starting Basic_scan.. "${reset}" "
IP_LIST=$(cat .valid_ip | grep for | awk '{print $5}' | grep '^[0-9]' | awk 'NR > 2')
nmap $IP_LIST -sn > .host_up
mv ./.valid_ip ./$DIR
mv ./.host_up ./$DIR
cd $DIR
for i in $(cat .host_up | grep for | awk '{print $5}' | grep '^[0-9]')
do 
nmap $i -sS -sV -T5 -p- --exclude 192.168.44.254 -oN nmap_scan_"${i}" > /dev/null 2>&1
#masscan --ports U:1-65535 $i --rate 10000 >> nmap_scan_"${i}"
done
brute_forcing
}

Full_scan(){
mkdir Full_scan > /dev/null 2>&1
mv ./.valid_ip ./Full_scan > /dev/null 2>&1
mv ./$DIR ./Full_scan > /dev/null 2>&1
cd Full_scan
mv ./.valid_ip ./$DIR
cd ./$DIR
echo -e " "${green}" [+] Starting Full_scan "${reset}" "
IP_LIST=$(cat .valid_ip | grep for | awk '{print $5}' | grep '^[0-9]' | awk 'NR > 2')
nmap $IP_LIST -sn > .host_up
for i in $(cat .host_up | grep for | awk '{print $5}' | grep '^[0-9]')
do 
nmap $i -sS -sV -T5 -p- --script=vuln --exclude 192.168.44.254 -oN nmap_scan_"${i}" -oX "${i}"_nmap.XML > /dev/null 2>&1
#masscan --ports U:1-65535 $i --rate 10000 >> nmap_scan_"${i}" > /dev/null 2>&1
done

vulnerability_mapping() {
for i in $(ls | grep -i XML)
do
searchsploit --nmap $i >> searchsploit_$i 
if [[ -s searchsploit_$"{i}" ]] ; then
rm searchsploit_$"{i}"
fi
done 

echo -e " "${green}" [+] Vulnerability mapping completed "${reset}" "
}

vulnerability_mapping
sleep 7

brute_forcing
}

scanning_options(){
echo -e " "${purple}" [?] Insert a name where results will be saved "${reset}" "
read -p "  [?] " DIR 
mkdir $DIR > /dev/null 2>&1
echo -e " "${green}" [+] Creating directory named: $DIR "${reset}" "
echo
echo -e " "${yellow}" [!] Please choose the scan that you would like to use "${reset}" "
echo -e " 
"${blue}"
  [1] Basic_scan

  [2] Full_scan
"${reset}"
"
read -p "  [?]  " ANSWER

#
case "$ANSWER" in
1) 
Basic_scan
;;
2)
Full_scan
esac
}

ip_validation(){
echo -e " "${yellow}" [!] Please insert the IP that you would like to scan "${reset}"  "
read -p "  [?]  " IP_S
check=$(nmap -sL $IP_S 2> .invalid_ip 1>.valid_ip)
if [[ ! -z $(cat .invalid_ip) ]] ; then 
echo
echo -e " "${red}"[-] Invalid IP { Did you mistype? } "${reset}" "
echo
echo -e " "${yellow}" [!] Restarting, try again  "${reset}" "
echo
ip_validation
else
echo -e " "${green}" [+] Valid IP "${reset}" "
echo 
scanning_options 
fi
}

# Gives the user the option to search inside previous results
file_explorer () {
echo -e " "${yellow}" [!] Would you like to search in previous files? [y,N] "${reset}"  "
read -p "  [?] " search 
if [[ $search == y ]] ; then
echo -e "  "${yellow}"[!] Please select the folder that you would like to search in "${reset}" "
cd $path/hunt_db 
for i in $(ls)
do 
echo -e " "${green}" $i "${reset}" "
done
read -p "  [?] " dir
cd $dir
echo -e " "${yellow}" [!] Please select the folder that you would like to search in "${reset}" "
for i in $(ls)
do 
echo -e " "${green}" $i "${reset}" "
done
read -p "  [?] " dir_2
cd $dir_2
echo -e " "${yellow}" [!] In which file would you like to take a look "${reset}"  "
for i in $(ls)
do 
echo -e " "${green}" $i "${reset}" "
done
read -p "  [?] " file
cat $file
echo -e " "${purple}" [?] Would you like to search for something else? [y,N]  "${reset}"  "
read -p "  [?] " re_search
if [[ $re_search == y ]] ; then 
echo -e " "${green}" [+] Restarting "${reset}" " 
sleep 5
clear
file_explorer
else 
echo -e " "${purple}" [?] Would you like to scan for exploits? [y,N]  "${reset}"  "
read -p "  [?] " ip_scan
	if [[ $ip_scan == y ]] ; then 
	ip_validation
	else 
	goodbye
	sleep 2
	exit
	fi
fi
elif [[ $search == N ]] ; then
echo -e " "${purple}" [?] Would you like to scan for exploits? [y,N]  "${reset}"  "
read -p "  [?] " ip_scan
	if [[ $ip_scan == y ]] ; then 
	ip_validation
	else 
	goodbye
	sleep 2
	exit
	fi
else
echo -e " "${red}"[-] Invalid answer, please try again "${reset}" "
file_explorer
fi
}
file_explorer

