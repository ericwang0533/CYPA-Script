#!/bin/bash

cat /etc/passwd | grep "/home" | cut -d":" -f1 > user-list.txt

vim user-list.txt

for user in 'user-list.txt' do
	echo "H3LL0@" | passwd --stdin "$user"
	chage -d 0 $user
done
