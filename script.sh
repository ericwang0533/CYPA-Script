#bin/bash
#cyberpatriot ubuntu script: h0dl3 

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
	find /home -type f \( -name "*.mp3" -o -name "*.txt" -o -name "*.xlsx" -o -name "*.mov" -o -name "*.mp4" -o -name "*.avi" -o -name 			"*.mpg" -o -name "*.mpeg" -o -name "*.flac" -o -name "*.m4a" -o -name "*.flv" -o -name "*.ogg" -o -name "*.gif" -o -name "*.png" -o -name "*.jpg" -o -name "*.jpeg" \) > find_results.txt
	
	#open find_results.txt
	less find_results.txt
}

#malware
malware(){
	#array of malware
	mal=(minetest nmap aircrack-ng ophcrack john logkeys hydra fakeroot crack medusa nikto tightvnc bind9 avahi cupsd postfix nginx frostwire wireshark vuze weplab pyrit mysql php5 proftpd-basic filezilla postgresql irssi telnet telnetd samba apache2 ftp vsftpd netcat* openssh-server)
	
	#loop through each application
	for i in ${mal[*]}; do
		echo -e "${RED}---------------------------------------------------------"
		echo -e "${LightBlue}Removing $i ...${NC}"
		apt-get autoremove --purge $i
	done
}

#good programs
goodprograms(){
	#install a variety of "good programs"
	echo -e "${RED}--------------------------------------------------------"
	echo -e "${LightBlue}Installing some good programs ...${NC}"
	sleep 2s
	apt-get install clamav lynis rkhunter chkrootkit -y
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
	chmod 640 /etc/shadow
	chown root:root /etc/shadow
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
	
	#view /etc/cron.(d)(daily)(hourly)(weekly)(monthly)
	read -p "$(echo -e 'View cron directories? y/n: '${CYAN})" yorn
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



#Starting the actual checklist, slowly calling all the functions above
echo -e "${CYAN}Starting Checklist"
echo -e "${RED}-------------------------------------------------------------"

#install vim
echo -e "${LightBlue}Installing Useful & Necessary Stuff ...${NC}"
sleep 1s
apt-get install vim debsums tree -y

#run debsums
echo -e "${LightBlue}Running a quick debsums check ...${NC}"
debsums -ce

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







#end of script
echo -e "${RED}-------------------------------------------------------------"
echo -e "${CYAN}Done with script! :)"
echo -e "${RED}-------------------------------------------------------------"
echo -e "${GREEN}REMINDERS"
echo -e "${CYAN}NONE YET${NC}"




































