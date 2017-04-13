FROM ubuntu

# required arguments
ARG PASSWORD
ARG PASSWORD_FILE

# optional arguments
ARG MODE=bcrypt
ARG HTTPS=True

# uncommon arguments
ARG PORT=5000

# filenames
ARG SERVER_SCRIPT=server.py
ARG CERT_FILE=server.crt
ARG KEY_FILE=server.key
ARG TOOL_GENERATE_PASSWORD_HASH=generate_password_hash.py

# destination paths
ARG TARGET_DIR=/opt/crypto-lab
ARG SHARED_DIR=${TARGET_DIR}/shared


RUN apt-get update && apt-get install -y \
    build-essential \
    libffi-dev \
    python-dev \
    python-pip

RUN pip install --upgrade pip

RUN pip install \
    bcrypt \
    flask \
    flask-login


RUN mkdir -p ${SHARED_DIR}
WORKDIR ${TARGET_DIR}

COPY ${TOOL_GENERATE_PASSWORD_HASH} .
RUN ./${TOOL_GENERATE_PASSWORD_HASH} ${MODE} ${PASSWORD} > ${PASSWORD_FILE}
RUN rm -f ${TOOL_GENERATE_PASSWORD_HASH}

COPY ${SERVER_SCRIPT} ${SHARED_DIR}
COPY ${CERT_FILE} ${SHARED_DIR}
COPY ${KEY_FILE} ${SHARED_DIR}

EXPOSE ${PORT}

CMD ${SHARED_DIR}/${SERVER_SCRIPT} ${PASSWORD_FILE} ${MODE} ${HTTPS}
