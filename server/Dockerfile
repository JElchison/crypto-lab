FROM ubuntu

ARG PASSWORD
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
ENV PASSWORD_FILE password.db
ENV TARGET_DIR /opt/crypto-lab/

RUN mkdir -p ${TARGET_DIR}
WORKDIR ${TARGET_DIR}

RUN echo ${PASSWORD} > ${PASSWORD_FILE}

COPY ${SERVER_SCRIPT} .
COPY ${CERT_FILE} .
COPY ${KEY_FILE} .

EXPOSE ${PORT}

CMD ./${SERVER_SCRIPT} ${MODE} ${HTTPS}
