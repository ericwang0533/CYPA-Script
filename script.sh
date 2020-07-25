#!/bin/bash
#cyberpatriot ubuntu script: h0dl3 

#color variables

RED='\033[0;31m'
LightBlue='\033[1;34m'
NC='\033[0m'


echo -e "${RED}------------------------------------------------------------"
echo -e "${LightBlue}Cyberpatriot Ubuntu Script: h0dl3"
echo -e "${RED}-------------------------------------------------------------"
echo -e "${LightBlue}FORESNIC README"
echo "PASSWORD"
echo -e "${RED}-------------------------------------------------------------"

#check if you are running as root
if [ $USER != root ]; then 
  #not root
	echo -e "${LightBlue}Retry as root: sudo su"
	exit
else
	#root
	echo -e "${LightBlue}Yay, you are root!"
fi

#Users/Groups/sudoers
#users first
users(){
	echo -e "Opening /etc/passwd ..."
	sleep 3s
	#open /etc/passwd
	vim /etc/passwd
}

#groups next
groups(){
	echo -e "Opening /etc/group ..."
	sleep 3s
	#open /etc/group
	vim /etc/group
}

#sudoers last
sudoers(){
	echo -e "Opening sudo visudo ..."
	sleep 3s
	#open /etc/sudoers
	sudo visudo
}



#Password Requirements
logindefs(){
	echo -e "Opening /etc/login.defs ..."
	sleep 3s
	#open /etc/login.defs
	vim /etc/login.defs
}

#PAM
#common-password
common-password(){
	echo -e "Installing cracklib ...${NC}"
	sleep 3s
	
	apt-get install libpam-cracklib -y
	
	echo -e "${LightBlue}Opening /etc/pam.d/common-password ..."
	sleep 3s
	#open /etc/pam.d/common-password
	vim /etc/pam.d/common-password	
}

#common-auth
common-auth(){
	echo -e "Opening /etc/pam.d/common-auth ..."
	sleep 3s
	#open /etc/pam.d/common-auth
	vim /etc/pam.d/common-auth
}



#Guest Access
#lightdm
lightdm(){
	echo -e "Opening /etc/lightdm/lightdm.conf ..."
	sleep 3s
	#open /etc/lightdm/lightdm.conf
	vim /etc/lightdm/lightdm.conf
}



#Updates
#gui
gui(){
	#open software and updates through gui
	software-properties-gtk
}

#updates
updates(){
	#update and upgrade
	#ask for confirmations before updating/upgrading
	read -p "$(echo -e ${LightBlue}'Ready to apt-get update? y/n: ')" yorn
	if [ $yorn == y ]; then
		echo -e "${NC}"
		apt-get update
		echo -e "${LightBlue}Done with apt-get update"
	fi
	
	read -p "$(echo -e 'Ready to apt-get upgrade? y/n: ')" yorn
	if [ $yorn == y ]; then
		echo -e "${NC}"
		apt-get upgrade
		echo -e "${LightBlue}Done with apt-get upgrade"
	fi

	read -p "$(echo -e 'Ready to apt-get dist-upgrade? y/n: ')" yorn
	if [ $yorn == y ]; then
		echo -e "${NC}"
		apt-get dist-upgrade
		echo -e "${LightBlue}Done with apt-get dist-upgrade"
	fi	
}



#Media/Malware
#media
media(){
	#find media files
	find /home -type f \( -name "*.mp3" -o -name "*.txt" -o -name "*.xlsx" -o -name "*.mov" -o -name "*.mp4" -o -name "*.avi" -o -name 			"*.mpg" -o -name "*.mpeg" -o -name "*.flac" -o -name "*.m4a" -o -name "*.flv" -o -name "*.ogg" -o -name "*.gif" -o -name "*.png" -o -name "*.jpg" -o -name "*.jpeg" \) > find_results.txt
	
	#open find_results.txt
	less find_results.txt


	read -p "$(echo -e 'Move on to Malware? y/n: ')" yorn
	if [ $yorn == n ]; then
		echo -e "${RED}Stopping Script :(${NC}"
		exit
	fi
}

#malware
malware(){
	#array of malware
	mal=(minetest ophcrack john logkeys hydra fakeroot crack medusa nikto tightvnc bind9 avahi cupsd postfix nginx frostwire wireshark vuze weplab pyrit mysql php5 proftpd-basic filezilla postgresql irssi telnet telnetd samba apache2 ftp vsftpd netcat* openssh-server)
	
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
	echo -e "${LightBlue}Installing some good programs ..."
	sleep 3s
	apt-get install clamav lynis rkhunter chkrootkit tree debsums -y
}



#File Permissions
fileperms(){
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
	sleep 3s
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
crontab(){
	echo -e "${LightBlue}Opening crontab ..."
	sleep 3s
	#view crontabs
	sudo crontab -e
	
	#view /etc/cron.(d)(daily)(hourly)(weekly)(monthly)
	read -p "$(echo -e 'View cron.d y/n: ')" yorn
	if [ $yorn == y ]; then
		ls -a /etc/cron.d
	fi

	read -p "$(echo -e ${LightBlue}'View cron.daily y/n: ')" yorn
	if [ $yorn == y ]; then
		ls -a /etc/cron.daily
	fi

  read -p "$(echo -e ${LightBlue}'View cron.hourly y/n: ')" yorn
	if [ $yorn == y ]; then
		ls -a /etc/cron.hourly
	fi

	read -p "$(echo -e ${LightBlue}'View cron.weekly y/n: ')" yorn
	if [ $yorn == y ]; then
		ls -a /etc/cron.weekly
	fi

	read -p "$(echo -e ${LightBlue}'View cron.monthly y/n: ')" yorn
	if [ $yorn == y ]; then
		ls -a /etc/cron.monthly
	fi
	
	read -p "$(echo -e ${LightBlue}'View /etc/rc.local y/n: ')" yorn
	if [ $yorn == y ]; then
		vim /etc/rc.local
	fi

}



#SSH
ssh(){
	#is ssh a critical service?
	read -p "$(echo -e ${LightBlue}'Is SSH a critical service? y/n: ${NC}')" yorn
	if [ $yorn == y ]; then
		#install ssh
		apt-get install ssh -y
		apt-get install openssh-server -y
		
		echo -e "${LightBlue}Opening /etc/ssh/sshd_config ..."
		sleep 3s
		#open /etc/ssh/sshd_config
		vim /etc/ssh/sshd_config

		#Restart SSH
		echo -e "Restarting SSH"
		sleep 3s
		service ssh restart
	elif [ $yorn == n ]; then
		#uninstall ssh
		apt-get autoremove --purge ssh
		apt-get autoremove --purge openssh-server
	fi
}







#Starting the actual checklist, slowly calling all the functions above
echo -e "${LightBlue}Starting Checklist"
echo -e "${RED}-------------------------------------------------------------"

#install vim
echo -e "Installing Vim ...${NC}"
sleep 1s
apt-get install vim -y

echo -e "${RED}-------------------------------------------------------------"
read -p "$(echo -e $LightBlue'Starting with Users/Groups, Move on? y/n/s (skip): ')" yorn

#check the value of yorn
if [ $yorn == n ]; then
	#n, stop script
	echo -e "Stopping Script :("
	exit
elif [ $yorn == s ]; then
	#s, skip
	echo -e "Skipped"
else
	#y, call the functions
	users
	groups
	sudoers
fi

#yorn: yes or no, ask to move on to the next task
echo -e "${RED}-------------------------------------------------------------"
read -p "$(echo -e $LightBlue'Move on to Password Requirements? y/n/s (skip): ')" yorn

#check the value of yorn
if [ $yorn == n ]; then
	#n, stop script
	echo -e "Stopping Script :("
	exit
elif [ $yorn == s ]; then
	#s, skip
	echo -e "Skipped"
else
	#y, call the functions
	logindefs
	common-password
	common-auth
fi

#yorn: yes or no, ask to move on to the next task
echo -e "${RED}-------------------------------------------------------------"
read -p "$(echo -e $LightBlue'Move on to Disabling Guest? y/n/s (skip): ')" yorn

#check the value of yorn
if [ $yorn == n ]; then
	#n, stop script
	echo -e "Stopping Script :("
	exit
elif [ $yorn == s ]; then
	#s, skip
	echo -e "Skipped"
else
	#y, call the functions
	lightdm
fi

#yorn: yes or no, ask to move on to the next task
echo -e "${RED}-------------------------------------------------------------"
read -p "$(echo -e $LightBlue'Move on to Updates? y/n/s (skip): ')" yorn

#check the value of yorn
if [ $yorn == n ]; then
	#n, stop script
	echo -e "Stopping Script :("
	exit
elif [ $yorn == s ]; then
	#s, skip
	echo -e "Skipped"
else
	#y, call the functions
	gui
	updates
fi

#yorn: yes or no, ask to move on to the next task
echo -e "${Red}-------------------------------------------------------------"
read -p "$(echo -e $LightBlue'Move on to Media/Programs? y/n/s (skip): ')" yorn

#check the value of yorn
if [ $yorn == n ]; then
	#n, stop script
	echo -e "Stopping Script :("
	exit
elif [ $yorn == s ]; then
	#s, skip
	echo -e "Skipped"
else
	#y, call the functions
	media
	malware
	goodprograms
fi

#yorn: yes or no, ask to move on to the next task
echo -e "${RED}-------------------------------------------------------------"
read -p "$(echo -e $LightBlue'Move on to File Permissions? y/n/s (skip): ')" yorn

#check the value of yorn
if [ $yorn == n ]; then
	#n, stop script
	echo -e "Stopping Script :("
	exit
elif [ $yorn == s ]; then
	#s, skip
	echo -e "Skipped"
else
	#y, call the functions
	fileperms
fi

#yorn: yes or no, ask to move on to the next task
echo -e "${RED}-------------------------------------------------------------"
read -p "$(echo -e $LightBlue'Move on to Firewall? y/n/s (skip): ')" yorn

#check the value of yorn
if [ $yorn == n ]; then
	#n, stop script
	echo -e "Stopping Script :("
	exit
elif [ $yorn == s ]; then
	#s, skip
	echo -e "Skipped"
else
	#y, call the functions
	firewall
fi

#yorn: yes or no, ask to move on to the next task
echo -e "${RED}-------------------------------------------------------------"
read -p "$(echo -e $LightBlue'Move on to Cron? y/n/s (skip): ')" yorn

#check the value of yorn
if [ $yorn == n ]; then
	#n, stop script
	echo -e "Stopping Script :("
	exit
elif [ $yorn == s ]; then
	#s, skip
	echo -e "Skipped"
else
	#y, call the functions
	crontab
fi



#yorn: yes or no, ask to move on to the next task
echo -e "${RED}-------------------------------------------------------------"
read -p "$(echo -e $LightBlue'Move on to SSH? y/n/s (skip): ')" yorn

#check the value of yorn
if [ $yorn == n ]; then
	#n, stop script
	echo -e "Stopping Script :("
	exit
elif [ $yorn == s ]; then
	#s, skip
	echo -e "Skipped"
else
	#y, call the functions
	ssh
fi










#end of script
echo -e "${RED}-------------------------------------------------------------"
echo -e "${LightBlue}Done with script! :)"





































