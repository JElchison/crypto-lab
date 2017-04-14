#!/bin/bash

set -eufx -o pipefail

HOST=$1
PORT=$2
HTTPS=$3

PASSWORD_FILE=nothing_to_see_here.txt

echo "password=$PASSWORD" > $PASSWORD_FILE


if [[ $HTTPS = "True" ]]; then
    watch "curl -v -s -k -X POST -d @$PASSWORD_FILE https://$HOST:$PORT/"
else
    watch "curl -v -s -X POST -d @$PASSWORD_FILE http://$HOST:$PORT/"
fi

