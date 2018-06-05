#!/bin/sh
# A shell script written to automate the AeriumX Masternode Setup Process

Green=$(echo '\033[00;32m')
Cyan=$(echo '\033[00;36m')
RED=$(echo '\033[00;31m')
YELLOW=$(echo '\033[00;33m')

echo "${Green}Im Starting to update!"
	apt update

echo "${Green}I've Finished updating! Now I need to upgrade."
	apt upgrade -y

echo "${Green}I've finished upgrading! Now I need to install dependencies"
	sudo apt-get install nano unzip git -y

echo "${Green}I've finished installing dependencies! Now I'll make folders and download the wallet."
	wget https://github.com/aeriumcoin/AeriumX/releases/download/v2.0/AeriumX-2.0.0-aarch64-linux-gnu.zip
	unzip AeriumX-2.0.0-aarch64-linux-gnu.zip
	chmod +x aeriumxd
	chmod +x aeriumx-cli
	
	./aeriumxd -daemon
	./aeriumxd -stop
echo "${Green}I've finished making folders and downloading the wallet! Now I'll create your aeriumx.conf file."	
	cd /root/.aeriumx/
	touch /root/.aeriumx/aeriumx.conf
	touch /root/.aeriumx/masternode.conf
	echo "rpcallowip=127.0.0.1" >> /root/.aeriumx/aeriumx.conf
	sleep 5
	echo "${Green}Enter an RPC username (It doesn't matter really what it is, just try to make it secure)"
		read username
			echo "rpcuser=$username" >> /root/.aeriumx/aeriumx.conf

	echo "${Green}Enter an RPC password(It doesn't matter really what it is, just try to make it secure)"
		read password
			echo "rpcpassword=$password" >> /root/.aeriumx/aeriumx.conf
	
	echo "server=1" >> /root/.aeriumx/aeriumx.conf
	echo "listen=1" >> /root/.aeriumx/aeriumx.conf
	echo "staking=1" >> /root/.aeriumx/aeriumx.conf
	echo "port=35407" >> /root/.aeriumx/aeriumx.conf
	echo "masternode=1" >> /root/.aeriumx/aeriumx.conf
	
	echo "${Green}What is the Global IP of your VPS? I'll put this into your config file for you because I'm so nice."
		read VPSip
			echo "masternodeaddr=$VPSip:35407" >> /root/.aeriumx/aeriumx.conf
			echo "bind=$VPSip:35407" >> /root/.aeriumx/aeriumx.conf
			echo "externalip=$VPSip:35407" >> /root/.aeriumx/aeriumx.conf
	         
	echo "${Green}What is your masternode genkey? I'll put this into your config file."
		read genkey
			echo "masternodeprivkey=$genkey" >> /root/.aeriumx/aeriumx.conf

	
echo "${YELLOW}Okay, it looks like you are all set. Let's startup the daemon!"
	cd /root/

	./aeriumxd -daemon
