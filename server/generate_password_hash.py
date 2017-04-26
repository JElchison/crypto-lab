#!/usr/bin/env python

import sys
import bcrypt
import hashlib
import base64


mode = sys.argv[1]
password = sys.argv[2]

if mode == "bcrypt":
    print bcrypt.hashpw(password, bcrypt.gensalt())

elif mode == "md5":
    m = hashlib.md5()
    m.update(password)
    print m.hexdigest()

elif mode == "base64":
    print base64.b64encode(password)

elif mode == "plaintext" or mode == "plaintext_time":
    print password

else:
    sys.exit(1)
