#!/bin/bash

set -eufx -o pipefail

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"


#
# install things
#

# update system
apt-get -y update; apt-get -y upgrade && apt-get -y autoremove

# automatically install critical security updates
apt-get -y install unattended-upgrades
dpkg-reconfigure --priority=low unattended-upgrades

# install docker
# https://docs.docker.com/engine/installation/linux/ubuntu/#os-requirements
apt-get -y remove docker docker-engine || true
apt-get -y install \
    linux-image-extra-"$(uname -r | egrep -o '^[0-9\.]+')" \
    linux-image-extra-virtual
apt-get -y install \
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
apt-get -y update
apt-get -y install docker-ce 
    
# install tcpdump
apt-get -y install tcpdump

# install python
apt-get -y install python

# install bcrypt
apt-get -y install \
    build-essential \
    libffi-dev \
    python-dev \
    python-pip
pip install --upgrade pip
pip install bcrypt


#
# variables
#

CERT_FILE=server.crt
KEY_FILE=server.key


#
# setup firewall
#

# allow inbound SSH
ufw allow ssh
# allow docker-docker traffic
ufw allow in on docker0
# skip confirmation
ufw --force enable


#
# configure things
#

# add student user
adduser --disabled-password --gecos "" student || true

# setup student SSH key
if [[ ! -f /home/student/.ssh/student ]]; then
  su student --login -c 'mkdir ~/.ssh' || true
  su student --login -c 'chmod 700 ~/.ssh'
  su student --login -c 'touch ~/.ssh/authorized_keys'
  su student --login -c 'chmod 600 ~/.ssh/authorized_keys'
  su student --login -c 'ssh-keygen -t ed25519 -f ~/.ssh/crypto-lab-student'
  su student --login -c 'cat ~/.ssh/crypto-lab-student.pub >> ~/.ssh/authorized_keys'
fi

# forbid student access to home directory
chmod o-rwx ~

# allow student user to run tcpdump
echo "student  ALL=(ALL)       NOPASSWD: /usr/sbin/tcpdump" > /etc/sudoers.d/tcpdump


#
# build client
#

pushd "$SCRIPT_DIR/client"
docker build -t lab_client .
popd


#
# server operations
#

pushd "$SCRIPT_DIR/server"

# build server
docker build -t lab_server .

# build self-signed TLS certificate, if doesn't exist
if [[ ! -f $CERT_FILE || ! -f $KEY_FILE ]]; then
  openssl req -x509 -days 365 -nodes -newkey rsa:2048 -keyout $KEY_FILE -out $CERT_FILE
  chown "$SUDO_USER": $CERT_FILE
  chown "$SUDO_USER": $KEY_FILE
fi

popd


#
# success
#

echo "Success"
