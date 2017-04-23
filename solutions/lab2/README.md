# lab2 Solution

### Steps

*From the remote EC2 instance (*not* your local machine):*
```bash
# see what processes are using port 5002
ps ax | grep 5002

# take a closer look at the python script using port 5002
less /opt/crypto-lab/shared/server.py

# the Flask application is serving HTTPS, so we can't sniff the password.  shucks.
# however, the password is stored in plaintext format.

# dump password file
cat /opt/crypto-lab/shared/password2.db
```


### Password

```
Always store passwords hashed and salted (never plain-text)
```
