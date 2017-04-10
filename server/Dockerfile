FROM ubuntu

ARG PASSWORD
ARG PASSWORD_FILE
ARG MODE=bcrypt
ARG HTTPS=True

RUN apt-get update && apt-get install -y \
    build-essential \
    libffi-dev \
    python-dev \
    python-pip

RUN pip install --upgrade pip

RUN pip install flask \
    flask-login \
    bcrypt

ENV PORT 5000
ENV SERVER_SCRIPT server.py
ENV CERT_FILE server.crt
ENV KEY_FILE server.key
ENV TOOLS_DIR tools
ENV GENERATE_HASH_TOOL generate_password_hash.py
ENV TARGET_DIR /opt/crypto-lab
ENV SHARED_DIR ${TARGET_DIR}/shared

RUN mkdir -p ${SHARED_DIR}
WORKDIR ${TARGET_DIR}

COPY ${TOOLS_DIR} .
RUN ${TOOLS_DIR}/${GENERATE_HASH_TOOL} ${MODE} ${PASSWORD} > ${PASSWORD_FILE}
RUN rm -rf ${TOOLS_DIR}

COPY ${SERVER_SCRIPT} ${SHARED_DIR}
COPY ${CERT_FILE} ${SHARED_DIR}
COPY ${KEY_FILE} ${SHARED_DIR}

EXPOSE ${PORT}

CMD ${SHARED_DIR}/${SERVER_SCRIPT} ${PASSWORD_FILE} ${MODE} ${HTTPS}
