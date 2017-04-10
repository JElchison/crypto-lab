FROM ubuntu

RUN apt-get update && apt-get install -y \
    build-essential \
    libffi-dev \
    python-dev \
    python-pip

RUN pip install --upgrade pip

RUN pip install flask \
    flask-login \
    bcrypt

ENV HOST localhost
ENV PORT 5001
ENV MODE plaintext
ENV HTTPS False
ENV PASSWORD Password1

ENV CLIENT client.sh
ENV SERVER server.py
ENV PASSWORD_FILE password.db

ENV TARGET_DIR /opt/crypto-lab/

EXPOSE ${PORT}

RUN mkdir -p ${TARGET_DIR}
WORKDIR ${TARGET_DIR}

RUN echo ${PASSWORD} > ${PASSWORD_FILE}

COPY ${SERVER} .
COPY ${CLIENT} .

CMD ./${SERVER} 0.0.0.0 ${PORT} ${MODE} ${HTTPS}
#CMD ./${CLIENT} ${HOST} ${PORT} ${HTTPS} ${PASSWORD}
