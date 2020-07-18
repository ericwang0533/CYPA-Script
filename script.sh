#!/bin/bash
#cyberpatriot ubuntu script: h0dl3 

echo "Cyberpatriot Ubuntu Script: h0dl3"
echo "FORESNIC README"


#check if you are running as root
if [ $USER != root ]; then 
  #not root
	echo "Retry as root: sudo su"
	exit
else
	#root
	echo "Yay, you are root!"
fi

#Users/Groups/sudoers
#users first
users(){
	#open /etc/passwd
	vim /etc/passwd
}

#groups next
groups(){
	#open /etc/group
	vim /etc/group
}

#sudoers last
sudoers(){
	#open /etc/sudoers
	vim /etc/sudoers
}



#Password Requirements
logindefs(){
	#open /etc/login.defs
	vim /etc/login.defs
}

#PAM
#common-password
common-password(){
	#open /etc/pam.d/common-password
	vim /etc/pam.d/common-password
	
	#install cracklib?
	read -p "Install cracklib? y/n: " yorn
	if [ $yorn == y ]; then
		apt-get install libpam-cracklib -y

		#reopen /etc/pam.d/common-password
		read -p "Reopen common-password? y/n: " yorn
		if [ $yorn == y ]; then
			vim /etc/pam.d/common-password
		fi
	fi
}

#common-auth
common-auth(){
	#open /etc/pam.d/common-auth
	vim /etc/pam.d/common-auth
}



#Guest Access
#lightdm
lightdm(){
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
	read -p "Ready to apt-get update? y/n: " yorn
	if [ $yorn == y ]; then
		apt-get update
		echo "Done with apt-get update"
	fi
	
	read -p "Ready to apt-get upgrade? y/n: " yorn
	if [ $yorn == y ]; then
		apt-get upgrade
		echo "Done with apt-get upgrade"
	fi

	read -p "Ready to apt-get dist-upgrade? y/n: " yorn
	if [ $yorn == y ]; then
		apt-get dist-upgrade
		echo "Done with apt-get dist-upgrade"
	fi	
}



#Media/Malware
#media
media(){
	#find media files
	find /home -type f \( -name "*.mp3" -o -name "*.txt" -o -name "*.xlsx" -o -name "*.mov" -o -name "*.mp4" -o -name "*.avi" -o -name 			"*.mpg" -o -name "*.mpeg" -o -name "*.flac" -o -name "*.m4a" -o -name "*.flv" -o -name "*.ogg" -o -name "*.gif" -o -name "*.png" -o -name "*.jpg" -o -name "*.jpeg" \) > find_results.txt
	
	#open find_results.txt
	less find_results.txt


	read -p "Move on to Malware? y/n: " yorn
	if [ $yorn == n ]; then
		echo "Stopping Script :("
		exit
	fi
}

#malware
malware(){
	#array of malware
	mal=(john logkeys hydra fakeroot crack medusa nikto tightvnc bind9 avahi cupsd postfix nginx frostwire wireshark vuze weplab pyrit mysql php5 proftpd-basic filezilla postgresql irssi telnet telnetd samba apache2 ftp vsftpd netcat* openssh)
	
	#loop through each application
	for i in ${mal[*]}; do
		apt-get autoremove --purge $i
	done
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
	#install firewall
	read -p "Install Firewall? y/n: " yorn
	if [ $yorn = y ]; then
		apt-get install ufw
	fi

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
	#view crontabs
	sudo crontab -e
	
	#view /etc/cron.(d)(daily)(hourly)(weekly)(monthly)
	read -p "View cron.d y/n: " yorn
	if [ $yorn == y ]; then
		ls /etc/cron.d
	fi

	read -p "View cron.daily y/n: " yorn
	if [ $yorn == y ]; then
		ls /etc/cron.daily
	fi

	read -p "View cron.hourly y/n: " yorn
	if [ $yorn == y ]; then
		ls /etc/cron.hourly
	fi

	read -p "View cron.weekly y/n: " yorn
	if [ $yorn == y ]; then
		ls /etc/cron.weekly
	fi

	read -p "View cron.monthly y/n: " yorn
	if [ $yorn == y ]; then
		ls /etc/cron.monthly
	fi
	
	read -p "View /etc/rc.local y/n: " yorn
	if [ $yorn == y ]; then
		vim /etc/rc.local
	fi

}



#SSH
ssh(){
	#is ssh a critical service?
	read -p "Is SSH a critical service? y/n: " yorn
	if [ $yorn == y ]; then
		#install ssh
		apt-get install ssh
		apt-get install openssh-server
		
		#open /etc/ssh/sshd_config
		vim /etc/ssh/sshd_config

		#Restart SSH?
		read -p "Restart SSH? y/n: " yorn
		if [ $yorn = y ]; then
			service ssh restart
		fi
	elif [ $yorn == n ]; then
		#uninstall ssh
		apt-get autoremove --purge ssh
		apt-get autoremove --purge openssh-server
	fi
}







#Starting the actual checklist, slowly calling all the functions above
echo "Starting Checklist"

read -p "Starting with Users/Groups, Move on? y/n/s (skip): " yorn

#check the value of yorn
if [ $yorn == n ]; then
	#n, stop script
	echo "Stopping Script :("
	exit
elif [ $yorn == s ]; then
	#s, skip
	echo "Skipped"
else
	#y, call the functions
	users
	groups
	sudoers
fi

#yorn: yes or no, ask to move on to the next task
read -p "Move on to Password Requirements? y/n/s (skip): " yorn

#check the value of yorn
if [ $yorn == n ]; then
	#n, stop script
	echo "Stopping Script :("
	exit
elif [ $yorn == s ]; then
	#s, skip
	echo "Skipped"
else
	#y, call the functions
	logindefs
	common-password
	common-auth
fi

#yorn: yes or no, ask to move on to the next task
read -p "Move on to Disabling Guest? y/n/s (skip): " yorn

#check the value of yorn
if [ $yorn == n ]; then
	#n, stop script
	echo "Stopping Script :("
	exit
elif [ $yorn == s ]; then
	#s, skip
	echo "Skipped"
else
	#y, call the functions
	lightdm
fi

#yorn: yes or no, ask to move on to the next task
read -p "Move on to Updates? y/n/s (skip): " yorn

#check the value of yorn
if [ $yorn == n ]; then
	#n, stop script
	echo "Stopping Script :("
	exit
elif [ $yorn == s ]; then
	#s, skip
	echo "Skipped"
else
	#y, call the functions
	gui
	updates
fi

#yorn: yes or no, ask to move on to the next task
read -p "Move on to Media/Malware? y/n/s (skip): " yorn

#check the value of yorn
if [ $yorn == n ]; then
	#n, stop script
	echo "Stopping Script :("
	exit
elif [ $yorn == s ]; then
	#s, skip
	echo "Skipped"
else
	#y, call the functions
	media
	malware
fi

#yorn: yes or no, ask to move on to the next task
read -p "Move on to File Permissions? y/n/s (skip): " yorn

#check the value of yorn
if [ $yorn == n ]; then
	#n, stop script
	echo "Stopping Script :("
	exit
elif [ $yorn == s ]; then
	#s, skip
	echo "Skipped"
else
	#y, call the functions
	fileperms
fi

#yorn: yes or no, ask to move on to the next task
read -p "Move on to Firewall? y/n/s (skip): " yorn

#check the value of yorn
if [ $yorn == n ]; then
	#n, stop script
	echo "Stopping Script :("
	exit
elif [ $yorn == s ]; then
	#s, skip
	echo "Skipped"
else
	#y, call the functions
	firewall
fi

#yorn: yes or no, ask to move on to the next task
read -p "Move on to Cron? y/n/s (skip): " yorn

#check the value of yorn
if [ $yorn == n ]; then
	#n, stop script
	echo "Stopping Script :("
	exit
elif [ $yorn == s ]; then
	#s, skip
	echo "Skipped"
else
	#y, call the functions
	crontab
fi



#yorn: yes or no, ask to move on to the next task
read -p "Move on to SSH? y/n/s (skip): " yorn

#check the value of yorn
if [ $yorn == n ]; then
	#n, stop script
	echo "Stopping Script :("
	exit
elif [ $yorn == s ]; then
	#s, skip
	echo "Skipped"
else
	#y, call the functions
	ssh
fi










#end of script
echo "Done with script! :)"





































