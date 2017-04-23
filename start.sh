#!/bin/bash

set -eufx -o pipefail

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"


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
# server operations
#

pushd "$SCRIPT_DIR/server"

# kill all Docker instances
docker kill $(docker ps -q) || true

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
# the final argument (PORT) is superfluous, but we leave it here so that the port number is seen in `ps ax`
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
# the final argument (PORT) is superfluous, but we leave it here so that the port number is seen in `ps ax`
docker run -d -p $PORT:$INTERNAL_PORT -v $SHARED_DIR:$SHARED_DIR:ro $IMAGE_NAME $SHARED_DIR/$SERVER_SCRIPT $PASSWORD_FILE $MODE $HTTPS $PORT
docker run -dt lab_client /bin/bash -c "PASSWORD=\"$PASSWORD\" ./$CLIENT_SCRIPT \"$DOCKER0_IP\" $PORT $HTTPS"

# lab3
PORT=5003
IMAGE_NAME=lab3_server
MODE=plaintext_time
PASSWORD="Always compare password hashes using constant-time comparison"
# password file intentionally not in SHARED_DIR
PASSWORD_FILE="$TARGET_DIR/password3.db"
HTTPS=True
docker build --build-arg PASSWORD="$PASSWORD" --build-arg PASSWORD_FILE="$PASSWORD_FILE" --build-arg MODE=$MODE -t $IMAGE_NAME .
# the final argument (PORT) is superfluous, but we leave it here so that the port number is seen in `ps ax`
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
# the final argument (PORT) is superfluous, but we leave it here so that the port number is seen in `ps ax`
docker run -d -p $PORT:$INTERNAL_PORT -v $SHARED_DIR:$SHARED_DIR:ro $IMAGE_NAME $SHARED_DIR/$SERVER_SCRIPT $PASSWORD_FILE $MODE $HTTPS $PORT
docker run -dt lab_client /bin/bash -c "PASSWORD=\"$PASSWORD\" ./$CLIENT_SCRIPT \"$DOCKER0_IP\" $PORT $HTTPS"

popd


#
# success
#

docker ps

echo "Success"
