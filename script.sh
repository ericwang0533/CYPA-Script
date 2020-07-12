#!/bin/bash
#cyberpatriot ubuntu script: h0dl3 

#test test commit

echo "Cyberpatriot Ubuntu Script: h0dl3"

#check if you are running as root
if [ $USER != root ]; then 
``#not root
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



#end of script
echo "Done with script! :)"





































