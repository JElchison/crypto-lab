#!/usr/bin/env python2

import sys
import requests
import operator
from requests.packages.urllib3.exceptions import InsecureRequestWarning


# ignore warning about self-signed cert
requests.packages.urllib3.disable_warnings(InsecureRequestWarning)

# characters to attempt in password
CHARSET = "abcdefghijklmnopqrstuvwxyz"


# make a single guess and return the time it took to make
def make_guess(guess, url, field):
    payload = {field: guess}
    r = requests.post(url, data=payload, verify=False)

    print r.elapsed, guess

    return r.elapsed


def crack_password(url, field):
    #
    # TODO: write your solution code here
    #
    pass


if __name__ == '__main__':
    # default URL to submit to
    url = 'https://localhost:5004/'
    # default name of form field containing the password we want to guess
    field = 'password'

    if len(sys.argv) >= 2:
        url = sys.argv[1]
    if len(sys.argv) >= 3:
        field = sys.argv[2]

    crack_password(url, field)
