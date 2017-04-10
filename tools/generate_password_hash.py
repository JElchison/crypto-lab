#!/usr/bin/env python

import sys
import bcrypt
import hashlib


mode = sys.argv[1]
password = sys.argv[2]

if mode == "bcrypt":
    print bcrypt.hashpw(password, bcrypt.gensalt())

elif mode == "md5":
    m = hashlib.md5()
    m.update(password)
    print m.hexdigest()

elif mode == "plaintext":
    print password

else:
    sys.exit(1)
