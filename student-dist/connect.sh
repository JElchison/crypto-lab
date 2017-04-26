#!/bin/bash

set -eufx -o pipefail

mkdir ~/.ssh || true
chmod 700 ~/.ssh
chmod 600 ~/.ssh/crypto-lab-student

ssh -nNTv -L 5001:localhost:5001 -L 5002:localhost:5002 -L 5003:localhost:5003 -L 5004:localhost:5004 -L 5005:localhost:5005 crypto-lab-student
