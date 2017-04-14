#!/bin/bash

set -eufx -o pipefail

SERVER_SCRIPT=server.py
CERT_FILE=server.crt
KEY_FILE=server.key
TOOL_GENERATE_PASSWORD_HASH=generate_password_hash.py

TARGET_DIR=/opt/crypto-lab
SHARED_DIR=${TARGET_DIR}/shared


pushd server

if [[ ! -f $CERT_FILE || ! -f $KEY_FILE ]]; then
  openssl req -x509 -days 365 -nodes -newkey rsa:2048 -keyout $KEY_FILE -out $CERT_FILE
fi

rm -rf $TARGET_DIR
mkdir -p $SHARED_DIR

cp -v $SERVER_SCRIPT $SHARED_DIR
chmod +x $SHARED_DIR/$SERVER_SCRIPT
cp -v $CERT_FILE $SHARED_DIR
cp -v $KEY_FILE $SHARED_DIR


MODE=bcrypt
PASSWORD="Always_use_TLS"
PASSWORD_FILE="$SHARED_DIR/password1.db"
HTTPS=False
./$TOOL_GENERATE_PASSWORD_HASH $MODE $PASSWORD > $PASSWORD_FILE
docker build --build-arg MODE=$MODE -t lab1_server .
docker run -d -p 5001:5000 -v $SHARED_DIR:$SHARED_DIR:ro lab1_server $SHARED_DIR/$SERVER_SCRIPT $PASSWORD_FILE $MODE $HTTPS

#MODE=plaintext
#PASSWORD="Always store passwords hashed and salted (never plain-text)"
#PASSWORD_FILE="$SHARED_DIR/password2.db"
#HTTPS=True
#./$TOOL_GENERATE_PASSWORD_HASH $MODE $PASSWORD > $PASSWORD_FILE
#docker build --build-arg MODE=$MODE -t lab2_server .
#docker run -d -p 5002:5000 -v $SHARED_DIR:$SHARED_DIR:ro lab2_server $SHARED_DIR/$SERVER_SCRIPT $PASSWORD_FILE $MODE $HTTPS

#MODE=plaintext
#PASSWORD="Always compare password hashes using constant-time comparison"
#HTTPS=True
#docker build --build-arg PASSWORD="$PASSWORD" --build-arg PASSWORD_FILE="$TARGET_DIR/password3.db" --build-arg MODE=$MODE -t lab3_server .
#docker run -d -p 5003:5000 -v $SHARED_DIR:$SHARED_DIR:ro lab3_server $SHARED_DIR/$SERVER_SCRIPT $PASSWORD_FILE $MODE $HTTPS

#MODE=md5
#PASSWORD="bcrypt is the best (current) method for password storage"
#PASSWORD_FILE="$SHARED_DIR/password4.db"
#HTTPS=True
#./$TOOL_GENERATE_PASSWORD_HASH $MODE $PASSWORD > $PASSWORD_FILE
#docker build --build-arg MODE=$MODE -t lab4_server .
#docker run -d -p 5004:5000 -v $SHARED_DIR:$SHARED_DIR:ro lab4_server $SHARED_DIR/$SERVER_SCRIPT $PASSWORD_FILE $MODE $HTTPS

popd


#pushd client

#docker build --build-arg PASSWORD="Always_use_TLS" --build-arg HOST= --build-arg HTTPS=False -t lab1_client .
#docker build --build-arg PASSWORD="foobar" --build-arg HOST= --build-arg HTTPS=True -t lab2_client .
#docker build --build-arg PASSWORD="foobar" --build-arg HOST= --build-arg HTTPS=True -t lab3_client .
#docker build --build-arg PASSWORD="foobar" --build-arg HOST= --build-arg HTTPS=True -t lab4_client .

#docker run -d lab1_client
#docker run -d lab2_client
#docker run -d lab3_client
#docker run -d lab4_client

#popd
