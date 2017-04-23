# lab4 Solution

### Steps

While student SSH'd into server:
```bash
# see what processes are using port 5004
ps ax | grep 5004

# take a closer look at the python script using port 5004
less /opt/crypto-lab/shared/server.py

# password is stored in MD5 format.  let's try reversing it using John the Ripper.
```

*From your local machine (not the remote EC2 instance):*
```bash
scp crypto-lab-student:/opt/crypto-lab/shared/password4.db .
john --format=raw-md5 password4.db
```

### Password

```
bcrypt is the best (current) method for password storage
```
