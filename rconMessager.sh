#!/bin/bash
#File where the captions are

#Put here your home dir (/home/username)
export HOME=
#This file will contain the adverts that will appear on your server (ex. /home/username/rconMessager/Adverts.txt)
FILE=

#RCON Config
##################################
#IP
HOST=
#Rcon Pass
PASSWORD=
#Rcon PORT
PORT=
#MCRCON COMMAND LINE (DO NOT MODIFY)
COMMAND="mcrcon -H $HOST -P $PORT -p $PASSWORD"

#FTP Config
#If your server does not allow run custom scripts you can run this script on your home and download the adverts file from the game server, so all admins can edit it.
#The script will download the file and send the lines on it over rcon
##################################
#Put a 1 to enable FTP fetching, put a 0 to disable
ENABLEFTP=0
#FTP user
FTPUSER=
#FTP password
FTPPASS=
#FTP PORT (Fill this even if it uses the default port)
FTPPORT=
#This is the file that will be downloaded from the FTP server (ex. /directory1/directory2/Adverts.txt)
FTPFILE=
#Time between captions (In seconds)
INTERVAL=90
#Initial value for counter
i=1


#The main loop
while true
do
	#Retrieves the Adverts.txt so we can change it from the server
	if [ $ENABLEFTP = 1 ]
	then
	wget --timeout 10 -t 3 ftp://"$FTPUSER":"$FTPPASS"@"$HOST":"FTPPORT""$FTPFILE" -O "$FILE"
	fi
	#refreshes the number of lines on every main loop iteration.
	FILELINES=$(wc -l < $FILE)
	#Counter loop, sends every line of the captions.txt one by one to the server via rcon
	until [ $i -gt $FILELINES ]
	do
		#I use cut with the counter to get every line one by one on every iteration, until it reaches maximum number of lines and resets the counter to the first one
		echo "RCONING!!!!!"
		$COMMAND "say $(cut -f$i -d$'\n' $FILE)"
        #Sums one to the counter
		i=$(( i+1 ))
		sleep $INTERVAL
	done
	#Resets the counter when the counter loops reaches $FILELINES
	i=1
done
