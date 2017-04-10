#!/bin/bash

set -eufx -o pipefail

HOST=$1
PORT=$2
HTTPS=$3


if [[ $HTTPS = "True" ]]; then
    watch "curl -v -s -k -X POST -d 'password=$PASSWORD' https://$HOST:$PORT/"
else
    watch "curl -v -s -X POST -d 'password=$PASSWORD' http://$HOST:$PORT/"
fi

