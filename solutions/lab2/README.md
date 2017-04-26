# lab2 Solution

### Steps

See what processes are using port 5002.

*From the lab server (not your local machine):*
```bash
student@crypto-lab:~$ ps ax | grep 5002
```

Take a closer look at the python script using port 5002.

*From the lab server (not your local machine):*
```bash
student@crypto-lab:~$ less /opt/crypto-lab/shared/server.py
```

The Flask application is serving HTTPS, so we can't sniff the password.  Shucks.

However, the password is stored in plaintext format.

Dump the password file.

*From the lab server (not your local machine):*
```bash
student@crypto-lab:~$ cat /opt/crypto-lab/shared/password2.db
```


### Password

```
Always store passwords hashed and salted (never in plaintext)
```
