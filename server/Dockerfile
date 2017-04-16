FROM ubuntu

ARG PASSWORD=foobar
ARG PASSWORD_FILE=/dev/null
ARG MODE=bcrypt

# uncommon arguments
ARG PORT=5000

# filenames
ARG TOOL_GENERATE_PASSWORD_HASH=generate_password_hash.py

# destination paths
ARG TARGET_DIR=/opt/crypto-lab
ARG SHARED_DIR=${TARGET_DIR}/shared


RUN apt-get update && apt-get install -y \
    python-pip

RUN pip install --upgrade pip

RUN pip install \
    flask \
    flask-login


RUN mkdir -p ${SHARED_DIR}
WORKDIR ${TARGET_DIR}

COPY ${TOOL_GENERATE_PASSWORD_HASH} .
RUN ./${TOOL_GENERATE_PASSWORD_HASH} ${MODE} "${PASSWORD}" > ${PASSWORD_FILE}
RUN rm -f ${TOOL_GENERATE_PASSWORD_HASH}

EXPOSE ${PORT}
