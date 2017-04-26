# lab3 Solution

### Steps

See what processes are using port 5003.

*From the lab server (not your local machine):*
```bash
student@crypto-lab:~$ ps ax | grep 5003
```

Take a closer look at the python script using port 5003.

*From the lab server (not your local machine):*
```bash
student@crypto-lab:~$ less /opt/crypto-lab/shared/server.py
```

The password isn't stored in plaintext format.  Shucks.

However, the password looks to be Base64, which is reversible.

Base64-decode the password file.

*From the lab server (not your local machine):*
```bash
student@crypto-lab:~$ base64 -d /opt/crypto-lab/shared/password3.db
```


### Password

```
Always store passwords hashed and salted (never use reversible encoding)
```
