#bin/bash
#cyberpatriot ubuntu script: created by Eric Wang 

#color variables

RED='\033[0;31m'
LightBlue='\033[1;34m'
GREEN='\033[1;32m'
CYAN='\033[1;36m'
NC='\033[0m'

echo -e "${RED}------------------------------------------------------------"
echo -e "${RED}------------------------------------------------------------"
echo -e "${RED}------------------------------------------------------------"
echo -e "${CYAN}Cyberpatriot Ubuntu Script: h0dl3"
echo -e "${RED}-------------------------------------------------------------"
echo -e "${GREEN}FORESNIC README"
echo "PASSWORD"
echo "SCREENSAVER"
echo "HISTORY"
echo "FILE GUI HISTORY"
echo -e "${RED}-------------------------------------------------------------"
read -p "$(echo -e ${LightBlue}'Are you ready? '${CYAN})"


#check if you are running as root
if [ $USER != root ]; then 
  #not root
	echo -e "${CYAN}Retry as root: sudo su"
	exit
else
	#root
	echo -e "${LightBlue}Yay, you are root!"
fi



#Updates
updates(){
	#open software and updates through gui
 	echo -e "${NC}"
	software-properties-gtk
	echo -e "${RED}---------------------------------------------------------"
	read -p "$(echo -e ${GREEN}'Ready to apt-get (update, upgrade, dist-upgrade)? y/n: '${CYAN})" yorn

	#update all at once in a seperate terminal
	if [ $yorn == y ]; then
    gnome-terminal -e "bash -c \"(apt-get update; apt-get upgrade -y; apt-get dist-upgrade -y)\"" & disown; sleep 2; 
	fi
}



#Users/Groups/sudoers
#users first
users(){
	echo -e "${LightBlue}Opening /etc/passwd ..."
	sleep 2s
	#open /etc/passwd
	vim /etc/passwd
}

#groups next
groups(){
	echo -e "${LightBlue}Opening /etc/group ..."
	sleep 2s
	#open /etc/group
	vim /etc/group
}

#sudoers last
sudoers(){
	echo -e "${LightBlue}Opening sudo visudo ..."
	sleep 2s
	#open /etc/sudoers
	sudo visudo
}



#Password Requirements
changepass(){
	echo -e "${LightBlue}Changing password of every user ...${NC}"
	sleep 2s
	
	#grab all the users
	cat /etc/passwd | grep "/home" | cut -d":" -f1 > user-list.txt
	
	#add root
	echo root >> user-list.txt

	#open user-list.txt
	vim user-list.txt

	#start changing passwords
	while IFS= read -r user; do
		echo -e "H3LL0@gmail.com\nH3LL0@gmail.com" | passwd $user
		echo -e "${LightBlue}Finished changing ${CYAN}$user's${LightBlue} password${NC}"
	done < user-list.txt

	echo -e "Done changing passwords"
	sleep 4s
}

logindefs(){
	echo -e "${LightBlue}Opening /etc/login.defs ..."
	sleep 2s
	#open /etc/login.defs
	vim /etc/login.defs
	
	read -p "$(echo -e ${LightBlue}'Replace /etc/login.defs? y/n: '${CYAN})" yorn
	#replce /etc/login/defs
	if [ $yorn == y ]; then
		cp /etc/login.defs /etc/login.defs1
		sed -i "s/PASS_MAX_DAYS	99999/PASS_MAX_DAYS 90/" /etc/login.defs
		sed -i "s/PASS_MIN_DAYS	0/PASS_MIN_DAYS 7/" /etc/login.defs
		sed -i "s/PASS_WARN_AGE	7/PASS_WARN_AGE 14/" /etc/login.defs
		
		#reoopen /etc/login.defs
		echo -e "${LightBlue}Reopening /etc/login.defs ..."
		sleep 2s
		vim /etc/login.defs	
	fi
}

#PAM
#common-password
common-password(){
	echo -e "${LightBlue}Installing cracklib ...${NC}"
	sleep 2s	
	apt-get install libpam-cracklib -y
	
	echo -e "${LightBlue}Opening /etc/pam.d/common-password ..."
	sleep 2s
	#open /etc/pam.d/common-password
	vim /etc/pam.d/common-password	

	#replace common-password
	read -p "$(echo -e ${LightBlue}'Replace /etc/pam.d/common-password? y/n: '${CYAN})" yorn
	if [ $yorn == y ]; then
		cp /etc/pam.d/common-password /etc/pam.d/common-password1
		sed -i "s/password\trequisite\t\t\tpam_cracklib.so/password\trequisite\t\t\tpam_cracklib.so dcredit=-1 ucredit=-1 lcredit=-1 ocredit=-1 reject_username minclass=3 maxrepeat=2 gecoscheck enforce_for_root/" /etc/pam.d/common-password
		sed -i "s/pam_unix.so/pam_unix.so rounds=8000 shadow remember=7/" /etc/pam.d/common-password
	
		#reopen /etc/pam.d/common-password
		echo -e "${LightBlue}Reopening /etc/pam.d/common-password ..."
		sleep 2s
		vim /etc/pam.d/common-password
	fi
}

#common-auth
common-auth(){
	echo -e "${LightBlue}Opening /etc/pam.d/common-auth ..."
	sleep 2s
	#open /etc/pam.d/common-auth
	vim /etc/pam.d/common-auth

	read -p "$(echo -e ${LightBlue}'Replace /etc/pam.d/common-auth? y/n: '${CYAN})" yorn
	if [ $yorn == y ]; then
		cp /etc/pam.d/common-auth /etc/pam.d/common-auth1
		echo -e "auth\trequired\t\t\tpam_tally2.so oneer=seccess audit silent deny=5 unlock_time=900" >> /etc/pam.d/common-auth
	
		#reopen /etc/pam.d/common-auth
		echo -e "${LightBlue}Reopening /etc/pam.d/common-auth ..."
		sleep 2s
		vim /etc/pam.d/common-auth
	fi
}



#Guest Access
#lightdm
lightdm(){
	echo -e "${LightBlue}Opening /etc/lightdm/lightdm.conf ..."
	sleep 2s
	#open /etc/lightdm/lightdm.conf
	vim /etc/lightdm/lightdm.conf
	
	#replace guest file
	read -p "$(echo -e ${LightBlue}'Replace guest file? y/n: '${CYAN})" yorn
	if [ $yorn == y ]; then
		cp /etc/lightdm/lightdm.conf /etc/lightdm/lightdm.conf1
		echo -e "[SeatDefaults]\nautologin-guest=false\nautologin-user=none\nautologin-user-timeout=0\nautologin-session=lightdm-autologin\nallow-guest=false\ngreeter-hide-users=true" > /etc/lightdm/lightdm.conf
		
		#reopen /etc/lightdm/lightdm.conf
		echo -e "${LightBlue}Reopening /etc/lightdm/lightdm.conf ..."
		sleep 2s
		vim /etc/lightdm/lightdm.conf
	fi
}



#Media/Malware
#media
media(){
	#find media files
	find /home -type f \( -name "*.zip" -o -name "*.wav" -o -name "*.tif" -o -name "*.wmv" -o -name "*.tiff" -o -name "*.tar" -o -name "*.mp6" -o -name "*.mp3" -o -name "*.txt" -o -name "*.xlsx" -o -name "*.mov" -o -name "*.mp4" -o -name "*.avi" -o -name "*.mpg" -o -name "*.mpeg" -o -name "*.flac" -o -name "*.m4a" -o -name "*.flv" -o -name "*.ogg" -o -name "*.gif" -o -name "*.png" -o -name "*.jpg" -o -name "*.jpeg" \) > findhome_results.txt

	#from /, exculding png
	find / -type f \( -name "*.zip" -o -name "*.wav" -o -name "*.tif" -o -name "*.wmv    " -o -name "*.tiff" -o -name "*.tar" -o -name "*.mp6" -o -name "*.mp3" -o -name "*.txt" -o -name "*.xlsx" -o -name "*.mov" -o -name "*.mp4" -o -name "*.avi" -o -name "*.mpg" -o -name "*.mpeg" -o -name "*.flac" -o -name "*.m4a" -o -name "*.flv" -o -name "*.ogg" -o -name "*.gif" -o -name "*.jpg" -o -name "*.jpeg" \) > find_results.txt
	
	#open find_results.txt
	less findhome_results.txt
	less find_results.txt
}

#malware
malware(){
	#array of malware
	malnames=(rsh freeciv minetest nmap aircrack-ng ophcrack john logkeys hydra fakeroot crack medusa nikto tightvnc bind9 avahi cupsd postfix nginx frostwire wireshark vuze weplab pyrit mysql php5 proftpd filezilla postgresql irssi telnet samba apache2 ftp vsftpd netcat ssh)
	mal=(rsh-client freeciv minetest "nmap zenmap" aircrack-ng ophcrack "john john-data" logkeys "hydra hydra-gtk" "fakeroot libfakeroot" crack "medusa libssh2-1" nikto "tightvnc xtightvncviewer" "bind9 bind9utils bind9-host" "avahi avahi-autoipd avahi-daemon avahi-utils" "cupsd " postfix "nginx nginx-core nginx-common" frostwire wireshark "vuze azureus" weplab pyrit "mysql-server php5-mysql" php5 proftpd-basic filezilla postgresql irssi "telnet openbsd-inetd telnetd" "samba samba-common samba-common-bin" "apache2 apache2.2-bin" ftp vsftpd netcat* "openssh-server openssh-client ssh")
	
	#loop through each application
	j = 1;
	for i in ${malnames[*]}; do
		echo -e "${RED}---------------------------------------------------------"
		#echo -e "${CYAN}$i"
		#echo -e "${malnames[i]}"
		#echo -e "$j"
		#echo -e "${mal[$j]}"
		echo -e "${LightBlue}Removing $i ...${NC}"
		apt-get autoremove --purge ${mal[$j]}
		j=$((j=j+1))
	done

	dpkg-query --list | grep -e "game" -e "freeciv" -e "minetest" -e "nmap" -e "crack" -e "john" -e "logkey" -e "hydra" -e "fakeroot" -e "medusa" -e "nikto" -e "tightvnc" -e "bind9" -e "avahi" -e "cupsd" -e "nginx" -e "wireshark" -e "frostwire" -e "vuze" -e "weplab" -e "pyrit" -e "mysql" -e "php" -e "ftp" -e "filezilla" -e "postgresql" -e "irssi" -e "telnet" -e "samba" -e "apache" -e "netcat" -e "ssh" -e "password" -e "trojan" -e "Trojan" -e "Hack" -e "hack" -e "server" > dpkg.txt
	less dpkg.txt
}

#good programs
goodprograms(){
	#install a variety of "good programs"
	echo -e "${RED}--------------------------------------------------------"
	echo -e "${LightBlue}Installing some good programs ...${NC}"
	sleep 2s
	apt-get install clamav lynis rkhunter chkrootkit synaptic -y
	#install git then linenum and linpeas
	echo -e "${RED}--------------------------------------------------------"
	echo -e "${LightBlue}Installing git${NC}"
	sleep 2s
	apt-get install git
	echo -e "${RED}--------------------------------------------------------"
	echo -e "${LightBlue}Installing LinEnum & LinPEAS${NC}"
	#install LinEnum
	git clone https://github.com/rebootuser/LinEnum
	#install LinPeas
	git clone https://github.com/carlospolop/privilege-escalation-awesome-scripts-suite
}

#firefox
firefox1(){
	echo -e "${RED}----------------------------------------------------------------"
	read -p "$(echo -e ${LightBlue}'Reinstall firefox? y/n: '${CYAN})" yorn
	if [ $yorn == y ]; then
		#kills firefox
		echo -e "${NC}Killing firefox ..."
		sleep 2s
		pkill -f firefox
		
		sudo apt-get --purge --reinstall install firefox -y
		
		#reopen firefox
		#read -p "$(echo -e ${LightBlue}'Enter username for reopening firefox: '${CYAN})" username
		#su $username -c "firefox &"
	fi
}

#treet
treet(){
	echo -e "${RED}----------------------------------------------------------------"
	read -p "$(echo -e ${LightBlue}'Run tree -a? y/n: '${CYAN})" yorn
	if [ $yorn == y ]; then
		tree / -f -a -o tree.txt
		less -r tree.txt
		tree /home -f -a -o treehome.txt
		less -r treehome.txt
	fi

	echo -e "${RED}--------------------------------------------------------------- "
	echo -e "${LightBlue}Moving to Malware ..."
	sleep 2s
}



#File Permissions
fileperms(){
	echo -e "${NC}"
	chown root:root /etc/securetty
	chmod 0600 /etc/securetty
	chmod 644 /etc/crontab
	chmod 640 /etc/ftpusers
	chmod 440 /etc/inetd.conf
	chmod 440 /etc/xinted.conf
	chmod 400 /etc/inetd.d
	chmod 644 /etc/hosts.allow
	chmod 440 /etc/sudoers
	chmod 600 /etc/shadow
	chown root:root /etc/shadow
	chmod 644 /etc/passwd
	chown root:root /etc/passwd
	chmod 644 /etc/group
	chown root:root /etc/group
	chmod 600 /etc/gshadow
	chown root:root /etc/gshadow
	chmod 700 /boot
	chown root:root /etc/anacrontab
	chmod 600 /etc/anacrontab
	chown root:root /etc/crontab
	chmod 600 /etc/crontab
	chown root:root /etc/cron.hourly
	chmod 600 /etc/cron.hourly
	chown root:root /etc/cron.daily
	chmod 600 /etc/cron.daily
	chown root:root /etc/cron.weekly
	chmod 600 /etc/cron.weekly
	chown root:root /etc/cron.monthly
	chmod 600 /etc/cron.monthly
	chown root:root /etc/cron.d
	chmod 600 /etc/cron.d
}



#Firewall
firewall(){
	echo -e "${LightBlue}Installing Firewall ...${NC}"
	sleep 2s
	#install firewall
	apt-get install ufw

	ufw enable
	ufw allow ssh
	ufw allow http
	ufw allow https
	ufw deny 23
	ufw deny 2049
	ufw deny 515
	ufw deny 111
	ufw logging high
	ufw status verbose
}



#Cron
crontab1(){
	echo -e "${LightBlue}Opening crontab ..."
	sleep 2s
	#view crontabs
	sudo crontab -e
	
	#cron.allow, at.allow, cron.deny, at.deny
	echo -e "${RED}-----------------------------------"
	echo -e "${LightBlue}Fixing cron.allow, at.allow, cron.deny and at.deny ...${NC}"
	sleep 2s
	
	#make backups
	cp /etc/cron.deny /etc/cron.deny1
	cp /etc/at.deny /etc/at.deny1
	
	#remove deny files
	rm -r /etc/cron.deny /etc/at.deny
	
	#make backups
	cp /etc/cron.allow /etc/cron.allow1
	cp /etc/at.allow /etc/at.allow1
	
	#fix allow files
	echo "root" | tee /etc/cron.allow /etc/at.allow > /dev/null
	chown root:root /etc/cron.allow /etc/at.allow
	chmod 400 /etc/cron.allow /etc/at.allow
	
	#cat the contents of old files
	echo -e "${LightBlue}Viewing old files ...${NC}"
	sleep 2s
	cat /etc/cron.deny1
	echo -e "${RED}-----------------------------------${NC}"
	cat /etc/at.deny1
	echo -e "${RED}-----------------------------------${NC}"
	cat /etc/cron.allow1
	echo -e "${RED}-----------------------------------${NC}"
	cat /etc/at.allow1
	
	echo -e "${LightBlue}Done with cron.allow, at.allow, cron.deny and at.deny"
	echo -e "${RED}-----------------------------------"

	#view /etc/cron.(d)(daily)(hourly)(weekly)(monthly) % /var/spool/cron/crontabs
	read -p "$(echo -e ${LightBlue}'View cron directories? y/n: '${CYAN})" yorn
	if [ $yorn == y ]; then
		echo -e "${RED}------------------------------------"
		echo -e "${LightBlue}/etc/cron.d${NC}"
		ls -a /etc/cron.d
		echo -e "${LightBlue}/etc/cron.daily${NC}"
		ls -a /etc/cron.daily
		echo -e "${LightBlue}/etc/cron.hourly${NC}"
		ls -a /etc/cron.hourly
		echo -e "${LightBlue}/etc/cron.weekly${NC}"
		ls -a /etc/cron.weekly
		echo -e "${LightBlue}/etc/cron.monthly${NC}"
		ls -a /etc/cron.monthly
		
		echo -e "${LightBlue}/var/spool/cron/crontabs"
		ls -a /var/spool/cron/crontabs
		echo -e "${RED}------------------------------------"
	fi

	read -p "$(echo -e ${LightBlue}'View /etc/rc.local y/n: '${CYAN})" yorn
	if [ $yorn == y ]; then
		vim /etc/rc.local
	fi

}

#cron of everyone (cron1)
cron1(){
	echo -e "${LightBlue}Viewing all cron ...${NC}"
	sleep 2s
	for user in $(getent passwd | cut -f1 -d: ); do
		echo -e "${LightBlue}$user${NC}" >> allcron.txt
		echo -e "${NC}$(crontab -u $user -l)${NC}" >> allcron.txt
	done
	less -r allcron.txt
}


#SSH
ssh(){
	#is ssh a critical service?
	read -p "$(echo -e ${LightBlue}'Is SSH a critical service? y/n: '${CYAN})" yorn
	echo -e "${NC}"
	if [ $yorn == y ]; then
		#install ssh
		apt-get install ssh -y
		apt-get install openssh-server -y
		
		echo -e "${LightBlue}Opening /etc/ssh/sshd_config ..."
		sleep 2s
		#open /etc/ssh/sshd_config
		vim /etc/ssh/sshd_config

		#Restart SSH
		echo -e "${LightBlue}Restarting SSH"
		sleep 2s
		sudo service ssh restart
		sudo service sshd restart
	elif [ $yorn == n ]; then
		#uninstall ssh
		apt-get autoremove --purge ssh openssh-server
	fi
}



#sysctl
sysctl1(){
	echo -e "${NC}"
	cp /etc/sysctl.conf /etc/sysctlorig.conf
	cp -f sysctl.conf /etc/sysctl.conf
	sysctl -e -p /etc/sysctl.conf
}



#antiviruses/scans
#rkhunter
rkhunter1(){
	echo -e "${LightBlue}Running rkhunter"
	rkhunter -c --sk > logs/rkhunter.txt 
	#(rkhunter -c --rwo > logs/rkhunter.txt) & disown; sleep 2;
}

#lynis
lynis1(){
	echo -e "${LightBlue}Running lynis"
	lynis -c --quick > logs/lynis.txt
}

#clamav
clamav1(){
	echo "3"
	#screw clam bruh, way too broke 
	clamscan -rbell -i / > logs/clamav.txt
}

#chkrootkit
chkrootkit1(){
	echo -e "${LightBlue}Running chkrootkit"
	chkrootkit -q > logs/chkrootkit.txt
}

#linpeas
linpeas(){
	echo -e "${LightBlue}Running linpeas"
	./privilege-escalation-awesome-scripts-suite/linPEAS/linpeas.sh > logs/linpeas.txt
}

#linenum
linenum(){
	echo -e "${LightBlue}Running linenum"
	./LinEnum/LinEnum.sh > logs/linenum.txt
}

#Starting the actual checklist, slowly calling all the functions above
echo -e "${CYAN}Starting Checklist"
echo -e "${RED}-------------------------------------------------------------"

#install vim
echo -e "${LightBlue}Installing Useful & Necessary Stuff ...${NC}"
sleep 1s
apt-get install vim debsums tree -y

#run debsums
echo -e "${LightBlue}Running a quick debsums check ...${NC}"
debsums -cae

#yorn: yes or no, ask to move on to the next task
echo -e "${RED}-------------------------------------------------------------"
read -p "$(echo -e $GREEN'Starting with Updates? y/n/s (skip): '${CYAN})" yorn

#check the value of yorn
if [ $yorn == n ]; then
	#n, stop script
	echo -e "Stopping Script :("
	exit
elif [ $yorn == y ]; then
	#y, call the functions
	updates
else
	#s, skip
	echo -e "Skipped"
fi

echo -e "${RED}-------------------------------------------------------------"
read -p "$(echo -e $GREEN'Move on to Users/Groups, Move on? y/n/s (skip): '${CYAN})" yorn

#check the value of yorn
if [ $yorn == n ]; then
	#n, stop script
	echo -e "Stopping Script :("
	exit
elif [ $yorn == y ]; then
	#y, call the functions
	users
	groups
	sudoers
else
	#s, skip
	echo -e "Skipped"
fi

#yorn: yes or no, ask to move on to the next task
echo -e "${RED}-------------------------------------------------------------"
read -p "$(echo -e $GREEN'Move on to Password Requirements? y/n/s (skip): '${CYAN})" yorn

#check the value of yorn
if [ $yorn == n ]; then
	#n, stop script
	echo -e "Stopping Script :("
	exit
elif [ $yorn == y ]; then
	#y, call the functions
	changepass
	logindefs
	common-password
	common-auth
else
	#s, skip
	echo -e "Skipped"
fi

#yorn: yes or no, ask to move on to the next task
echo -e "${RED}-------------------------------------------------------------"
read -p "$(echo -e $GREEN'Move on to Disabling Guest? y/n/s (skip): '${CYAN})" yorn

#check the value of yorn
if [ $yorn == n ]; then
	#n, stop script
	echo -e "Stopping Script :("
	exit
elif [ $yorn == y ]; then
	#y, call the functions
	lightdm
else
	#s, skip
	echo -e "Skipped"
fi

#yorn: yes or no, ask to move on to the next task
echo -e "${RED}-------------------------------------------------------------"
read -p "$(echo -e $GREEN'Move on to Media/Programs? y/n/s (skip): '${CYAN})" yorn

#check the value of yorn
if [ $yorn == n ]; then
	#n, stop script
	echo -e "Stopping Script :("
	exit
elif [ $yorn == y ]; then
	#y, call the functions
	media
	treet
	malware
	goodprograms
	firefox1
else
	#s, skip
	echo -e "Skipped"
fi

#yorn: yes or no, ask to move on to the next task
echo -e "${RED}-------------------------------------------------------------"
read -p "$(echo -e $GREEN'Move on to File Permissions? y/n/s (skip): '${CYAN})" yorn

#check the value of yorn
if [ $yorn == n ]; then
	#n, stop script
	echo -e "Stopping Script :("
	exit
elif [ $yorn == y ]; then
	#y, call the functions
	fileperms
else
	#s, skip
	echo -e "Skipped"
fi

#yorn: yes or no, ask to move on to the next task
echo -e "${RED}-------------------------------------------------------------"
read -p "$(echo -e $GREEN'Move on to Firewall? y/n/s (skip): '${CYAN})" yorn

#check the value of yorn
if [ $yorn == n ]; then
	#n, stop script
	echo -e "Stopping Script :("
	exit
elif [ $yorn == y ]; then
	#y, call the functions
	firewall
else
	#s, skip
	echo -e "Skipped"
fi

#yorn: yes or no, ask to move on to the next task
echo -e "${RED}-------------------------------------------------------------"
read -p "$(echo -e $GREEN'Move on to Cron? y/n/s (skip): '${CYAN})" yorn

#check the value of yorn
if [ $yorn == n ]; then
	#n, stop script
	echo -e "Stopping Script :("
	exit
elif [ $yorn == y ]; then
	#y, call the functions
	crontab1
	cron1
else
	#s, skip
	echo -e "Skipped"
fi



#yorn: yes or no, ask to move on to the next task
echo -e "${RED}-------------------------------------------------------------"
read -p "$(echo -e $GREEN'Move on to SSH? y/n/s (skip): '${CYAN})" yorn

#check the value of yorn
if [ $yorn == n ]; then
	#n, stop script
	echo -e "Stopping Script :("
	exit
elif [ $yorn == y ]; then
	#y, call the functions
	ssh
else
	#s, skip
	echo -e "Skipped"
fi



#yorn: yes or no, ask to move on to the next task
echo -e "${RED}-------------------------------------------------------------"
read -p "$(echo -e $GREEN'Move on to Sysctl? y/n/s (skip): '${CYAN})" yorn

#check the value of yorn
if [ $yorn == n ]; then
	#n, stop script
	echo -e "Stopping Script :("
	exit
elif [ $yorn == y ]; then
	#y, call the functions
	sysctl1
else
	#s, skip
	echo -e "Skipped"
fi



#yorn: yes or no, ask to move on to the next task
echo -e "${RED}-------------------------------------------------------------"
read -p "$(echo -e $GREEN'Move on to setting up antiviruses/scans? y/n/s (skip): '${CYAN})" yorn

#check the value of yorn
if [ $yorn == n ]; then
	#n, stop script
	echo -e "Stopping Script :("
	exit
elif [ $yorn == y ]; then
	#y, call the functions
	#rm -rf logs
	mkdir logs
	rkhunter1
	lynis1
	#clamav1
	chkrootkit1
	linpeas
	linenum
else
	#s, skip
	echo -e "Skipped"
fi




#end of script
echo -e "${RED}-------------------------------------------------------------"
echo -e "${CYAN}Done with script! :)"
echo -e "${RED}-------------------------------------------------------------"
echo -e "${GREEN}REMINDERS"
echo -e "${RED}-------------------------------------------------------------"
echo -e "${CYAN}ROOT PASSWORD LOCK${NC}"
echo -e "${CYAN}CHECK LOGS${NC}"
echo -e "${CYAN}MEDIA${NC}"
echo -e "${CYAN}SYNAPTIC${NC}"
echo -e "${CYAN}ALIASES${NC}"
echo -e "${CYAN}/ETC${NC}"
echo -e "${CYAN}FIREFOX${NC}"
echo -e "${CYAN}CRITICAL SERVICES${NC}"
echo -e "${CYAN}README${NC}"
echo -e "${CYAN}NOTES${NC}"
echo -e "${CYAN}trust the process${NC}"





































