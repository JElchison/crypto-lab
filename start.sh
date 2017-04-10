#!/bin/bash

set -eufx -o pipefail


pushd server

docker build --build-arg PASSWORD="Always_use_TLS" --build-arg PASSWORD_FILE="/opt/crypto-lab/shared/password1.db" --build-arg MODE=bcrypt --build-arg HTTPS=False -t lab1_server .
#docker build --build-arg PASSWORD="Always store passwords hashed and salted (never plain-text)" --build-arg PASSWORD_FILE="/opt/crypto-lab/shared/password2.db" --build-arg MODE=plaintext --build-arg HTTPS=True -t lab2_server .
#docker build --build-arg PASSWORD="Always compare password hashes using constant-time comparison" --build-arg PASSWORD_FILE="/opt/crypto-lab/password3.db" --build-arg MODE=plaintext --build-arg HTTPS=True -t lab3_server .
#docker build --build-arg PASSWORD="bcrypt is the best (current) method for password storage" --build-arg PASSWORD_FILE="/opt/crypto-lab/shared/password4.db" --build-arg MODE=md5 --build-arg HTTPS=True -t lab4_server .

docker run -d -p 5001:5000 -v /opt/crypto-lab/shared:/opt/crypto-lab/shared:ro lab1_server
#docker run -d -p 5002:5000 -v /opt/crypto-lab/shared:/opt/crypto-lab/shared:ro lab2_server
#docker run -d -p 5003:5000 -v /opt/crypto-lab/shared:/opt/crypto-lab/shared:ro lab3_server
#docker run -d -p 5004:5000 -v /opt/crypto-lab/shared:/opt/crypto-lab/shared:ro lab4_server

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
