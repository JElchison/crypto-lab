FROM ubuntu

RUN apt update && apt install -y \
    build-essential \
    libffi-dev \
    python-dev \

RUN pip install flask \
    flask-login \
    bcrypt \

ENV PASSWORD Password1
ENV PORT 5001

EXPOSE ${PORT}

COPY ../server.py ~
CMD echo ${PASSWORD} > password.db
CMD ./server.py 0.0.0.0 ${PORT} plaintext False

COPY ../client.sh ~
CMD ./client.sh localhost ${PORT} False ${PASSWORD}

