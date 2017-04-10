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

EXPOSE ${PORT}

CMD echo ${PASSWORD} > ${PASSWORD_FILE}

COPY ${SERVER} ~
CMD ./${SERVER} 0.0.0.0 ${PORT} ${MODE} ${HTTPS}

COPY ${CLIENT} ~
CMD ./${CLIENT} ${HOST} ${PORT} ${HTTPS} ${PASSWORD}
