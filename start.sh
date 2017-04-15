#!/bin/bash

set -eufx -o pipefail


#
# install things
#

# update system
apt -y update; apt -y upgrade && apt -y autoremove

# automatically install critical security updates
apt install unattended-upgrades
dpkg-reconfigure --priority=low unattended-upgrades

# install docker
# https://docs.docker.com/engine/installation/linux/ubuntu/#os-requirements
apt remove docker docker-engine || true
apt -y install \
    linux-image-extra-$(uname -r) \
    linux-image-extra-virtual
apt -y install \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
apt-key fingerprint 0EBFCD88
add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
apt -y update
apt -y install docker-ce 
    
# install tcpdump
apt install tcpdump


#
# variables
#

CLIENT_SCRIPT=client.sh
SERVER_SCRIPT=server.py
CERT_FILE=server.crt
KEY_FILE=server.key
TOOL_GENERATE_PASSWORD_HASH=generate_password_hash.py

TARGET_DIR=/opt/crypto-lab
SHARED_DIR=${TARGET_DIR}/shared

DOCKER0_IP=$(ip -f inet -o addr show docker0 | cut -d\  -f 7 | cut -d/ -f 1)
INTERNAL_PORT=5000


#
# configure things
#

# setup firewall to allow ony SSH
ufw allow ssh
ufw --force enable

# add student user
adduser --disabled-password --gecos "" student || true

# setup student SSH key
su student --login -c 'mkdir ~/.ssh'
su student --login -c 'chmod 700 ~/.ssh'
su student --login -c 'ssh-keygen -t ed25519 -f /home/student/.ssh/id_ed25519'


#
# build client
#

pushd client
docker build -t lab_client .
popd


#
# server operations
#

pushd server

# build server
docker build -t lab_server .

# build self-signed TLS certificate, if doesn't exist
if [[ ! -f $CERT_FILE || ! -f $KEY_FILE ]]; then
  openssl req -x509 -days 365 -nodes -newkey rsa:2048 -keyout $KEY_FILE -out $CERT_FILE
  chown "$SUDO_USER": $CERT_FILE
  chown "$SUDO_USER": $KEY_FILE
fi

# cleanup target directory from last run
rm -rf $TARGET_DIR
# make new empty tree
mkdir -p $SHARED_DIR

# copy server files
cp -fv $SERVER_SCRIPT $SHARED_DIR
chmod +x $SHARED_DIR/$SERVER_SCRIPT
cp -fv $CERT_FILE $SHARED_DIR
cp -fv $KEY_FILE $SHARED_DIR

# lab1
PORT=5001
IMAGE_NAME=lab_server
MODE=bcrypt
PASSWORD="Always_use_TLS"
PASSWORD_FILE="$SHARED_DIR/password1.db"
HTTPS=False
./$TOOL_GENERATE_PASSWORD_HASH $MODE "$PASSWORD" > $PASSWORD_FILE
docker run -d -p $PORT:$INTERNAL_PORT -v $SHARED_DIR:$SHARED_DIR:ro $IMAGE_NAME $SHARED_DIR/$SERVER_SCRIPT $PASSWORD_FILE $MODE $HTTPS $PORT
docker run -dt lab_client /bin/bash -c "PASSWORD=\"$PASSWORD\" ./$CLIENT_SCRIPT \"$DOCKER0_IP\" $PORT $HTTPS"

# lab2
PORT=5002
IMAGE_NAME=lab_server
MODE=plaintext
PASSWORD="Always store passwords hashed and salted (never plain-text)"
PASSWORD_FILE="$SHARED_DIR/password2.db"
HTTPS=True
./$TOOL_GENERATE_PASSWORD_HASH $MODE "$PASSWORD" > $PASSWORD_FILE
docker run -d -p $PORT:$INTERNAL_PORT -v $SHARED_DIR:$SHARED_DIR:ro $IMAGE_NAME $SHARED_DIR/$SERVER_SCRIPT $PASSWORD_FILE $MODE $HTTPS $PORT
docker run -dt lab_client /bin/bash -c "PASSWORD=\"$PASSWORD\" ./$CLIENT_SCRIPT \"$DOCKER0_IP\" $PORT $HTTPS"

# lab3
PORT=5003
IMAGE_NAME=lab3_server
MODE=plaintext_time
PASSWORD="Always compare password hashes using constant-time comparison"
PASSWORD_FILE="$TARGET_DIR/password3.db"
HTTPS=True
docker build --build-arg PASSWORD="$PASSWORD" --build-arg PASSWORD_FILE="$PASSWORD_FILE" --build-arg MODE=$MODE -t $IMAGE_NAME .
docker run -d -p $PORT:$INTERNAL_PORT -v $SHARED_DIR:$SHARED_DIR:ro $IMAGE_NAME $SHARED_DIR/$SERVER_SCRIPT $PASSWORD_FILE $MODE $HTTPS $PORT
docker run -dt lab_client /bin/bash -c "PASSWORD=\"$PASSWORD\" ./$CLIENT_SCRIPT \"$DOCKER0_IP\" $PORT $HTTPS"

# lab4
PORT=5004
IMAGE_NAME=lab_server
MODE=md5
PASSWORD="bcrypt is the best (current) method for password storage"
PASSWORD_FILE="$SHARED_DIR/password4.db"
HTTPS=True
./$TOOL_GENERATE_PASSWORD_HASH $MODE "$PASSWORD" > $PASSWORD_FILE
docker run -d -p $PORT:$INTERNAL_PORT -v $SHARED_DIR:$SHARED_DIR:ro $IMAGE_NAME $SHARED_DIR/$SERVER_SCRIPT $PASSWORD_FILE $MODE $HTTPS $PORT
docker run -dt lab_client /bin/bash -c "PASSWORD=\"$PASSWORD\" ./$CLIENT_SCRIPT \"$DOCKER0_IP\" $PORT $HTTPS"

popd


#
# print success
#

echo "Success"
