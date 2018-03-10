#/bin/bash

cd ~

echo "*********************  I'm here to help you :) ***********************"
echo && echo && echo


sudo apt-get update
sudo apt-get -y upgrade
sudo apt-get install -y software-properties-common
sudo add-apt-repository -y ppa:bitcoin/bitcoin
sudo apt-get update
sudo apt-get install -y build-essential libtool autotools-dev automake pkg-config libssl-dev libevent-dev bsdmainutils libboost-all-dev libdb4.8-dev libdb4.8++-dev libminiupnpc-dev libzmq3-dev tmux
sudo apt-get install -y libgmp3-dev

sudo apt-get update

cd /var
sudo touch swap.img
sudo chmod 600 swap.img
sudo dd if=/dev/zero of=/var/swap.img bs=1024k count=2000
sudo mkswap /var/swap.img
sudo swapon /var/swap.img
sudo free
sudo echo "/var/swap.img none swap sw 0 0" >> /etc/fstab
cd

sudo apt-get install -y ufw
sudo ufw allow ssh/tcp
sudo ufw logging on
#sudo ufw enable
sudo ufw status

mkdir -p ~/bin
echo 'export PATH=~/bin:$PATH' > ~/.bash_aliases
source ~/.bashrc


git clone https://github.com/mycelliumcoin/MycelliumMN
cd MycelliumMN/src/leveldb && chmod 777 * && cd .. && make -f makefile.unix


CONF_DIR=~/.Myce/
CONF_FILE=Myce.conf

echo "rpcuser=myce"`shuf -i 100000-10000000 -n 1` >> $CONF_DIR/$CONF_FILE
echo "rpcpassword=mycelove"`shuf -i 100000-10000000 -n 1` >> $CONF_DIR/$CONF_FILE
echo "rpcallowip=127.0.0.1" >> $CONF_DIR/$CONF_FILE
echo "listen=1" >> $CONF_DIR/$CONF_FILE
echo "server=1" >> $CONF_DIR/$CONF_FILE
echo "daemon=1" >> $CONF_DIR/$CONF_FILE
echo "logtimestamps=1" >> $CONF_DIR/$CONF_FILE
echo "maxconnections=256" >> $CONF_DIR/$CONF_FILE
echo "" >> $CONF_DIR/$CONF_FILE


cd ~/MycelliumMN/src
./myced
echo "PRESS ENTER[] to continue"
read

echo ""
echo "**********************************************************************"
echo ""
echo "Let's configure your masternode..."
echo "Type the IP of this server (it's located on your dashboard) then press [ENTER]:"
hostname -I
read IP
echo ""
echo "**********************************************************************"
echo ""
echo "Type the PORT your going to use on this server (port: 23511 recommended for MYCE) then press [ENTER]:"
read PORT

./myced masternode genkey
echo "This is you Private Key (copy and paste it here, then press ENTER[])"
read PRIVKEY
./myced stop
echo "Now copy and paste it somewhere safe, then press ENTER[]"
read 

echo ""
echo "**********************************************************************"
echo ""
echo "                          Thanks I'll continue                        "
echo ""
echo "**********************************************************************"
echo ""





echo "" >> $CONF_DIR/$CONF_FILE
echo "port=$PORT" >> $CONF_DIR/$CONF_FILE
echo "masternodeaddr=$IP:$PORT" >> $CONF_DIR/$CONF_FILE
echo "masternodeprivkey=$PRIVKEY" >> $CONF_DIR/$CONF_FILE
echo "masternode=1" >> $CONF_DIR/$CONF_FILE
echo "" >> $CONF_DIR/$CONF_FILE
sudo ufw allow $PORT/tcp

./myced -daemon