import sys
import bcrypt


password = sys.argv[1]

print bcrypt.hashpw(password, bcrypt.gensalt())
