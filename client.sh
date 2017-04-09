#!/bin/bash

watch "curl -v -s -X POST -d 'password=Always_use_TLS' http://localhost:5000/"
#watch "curl -v -s -k -X POST -d 'password=Always_use_TLS' https://localhost:5000/"
