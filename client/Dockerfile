FROM ubuntu

# filenames
ARG CLIENT_SCRIPT=client.sh

# destination paths
ARG TARGET_DIR=/opt/crypto-lab

RUN apt-get -y update && apt-get -y install \
    curl


WORKDIR ${TARGET_DIR}

COPY ${CLIENT_SCRIPT} .
