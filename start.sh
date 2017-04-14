#!/bin/bash

set -eufx -o pipefail

CLIENT_SCRIPT=client.sh
SERVER_SCRIPT=server.py
CERT_FILE=server.crt
KEY_FILE=server.key
TOOL_GENERATE_PASSWORD_HASH=generate_password_hash.py

TARGET_DIR=/opt/crypto-lab
SHARED_DIR=${TARGET_DIR}/shared

DOCKER0_IP=$(ip -f inet -o addr show docker0 | cut -d\  -f 7 | cut -d/ -f 1)
INTERNAL_PORT=5000

pushd client
docker build -t lab_client .
popd


pushd server

docker build -t lab_server .

if [[ ! -f $CERT_FILE || ! -f $KEY_FILE ]]; then
  openssl req -x509 -days 365 -nodes -newkey rsa:2048 -keyout $KEY_FILE -out $CERT_FILE
  chown "$SUDO_USER": $CERT_FILE
  chown "$SUDO_USER": $KEY_FILE
fi

rm -rf $TARGET_DIR
mkdir -p $SHARED_DIR

cp -fv $SERVER_SCRIPT $SHARED_DIR
chmod +x $SHARED_DIR/$SERVER_SCRIPT
cp -fv $CERT_FILE $SHARED_DIR
cp -fv $KEY_FILE $SHARED_DIR


PORT=5001
IMAGE_NAME=lab_server
MODE=bcrypt
PASSWORD="Always_use_TLS"
PASSWORD_FILE="$SHARED_DIR/password1.db"
HTTPS=False
./$TOOL_GENERATE_PASSWORD_HASH $MODE "$PASSWORD" > $PASSWORD_FILE
docker run -d -p $PORT:$INTERNAL_PORT -v $SHARED_DIR:$SHARED_DIR:ro $IMAGE_NAME $SHARED_DIR/$SERVER_SCRIPT $PASSWORD_FILE $MODE $HTTPS $PORT
docker run -dt lab_client /bin/bash -c "PASSWORD=\"$PASSWORD\" ./$CLIENT_SCRIPT \"$DOCKER0_IP\" $PORT $HTTPS"

PORT=5002
IMAGE_NAME=lab_server
MODE=plaintext
PASSWORD="Always store passwords hashed and salted (never plain-text)"
PASSWORD_FILE="$SHARED_DIR/password2.db"
HTTPS=True
./$TOOL_GENERATE_PASSWORD_HASH $MODE "$PASSWORD" > $PASSWORD_FILE
docker run -d -p $PORT:$INTERNAL_PORT -v $SHARED_DIR:$SHARED_DIR:ro $IMAGE_NAME $SHARED_DIR/$SERVER_SCRIPT $PASSWORD_FILE $MODE $HTTPS $PORT
docker run -dt lab_client /bin/bash -c "PASSWORD=\"$PASSWORD\" ./$CLIENT_SCRIPT \"$DOCKER0_IP\" $PORT $HTTPS"

PORT=5003
IMAGE_NAME=lab3_server
MODE=plaintext_time
PASSWORD="Always compare password hashes using constant-time comparison"
PASSWORD_FILE="$TARGET_DIR/password3.db"
HTTPS=True
docker build --build-arg PASSWORD="$PASSWORD" --build-arg PASSWORD_FILE="$PASSWORD_FILE" --build-arg MODE=$MODE -t $IMAGE_NAME .
docker run -d -p $PORT:$INTERNAL_PORT -v $SHARED_DIR:$SHARED_DIR:ro $IMAGE_NAME $SHARED_DIR/$SERVER_SCRIPT $PASSWORD_FILE $MODE $HTTPS $PORT
docker run -dt lab_client /bin/bash -c "PASSWORD=\"$PASSWORD\" ./$CLIENT_SCRIPT \"$DOCKER0_IP\" $PORT $HTTPS"

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

echo "Success"
