# lab4 Solution

### Steps

See what processes are using port 5004.

*From the remote EC2 instance (not your local machine):*
```bash
student@crypto-lab:~$ ps ax | grep 5004
```

Take a closer look at the python script using port 5004.

*From the remote EC2 instance (not your local machine):*
```bash
student@crypto-lab:~$ less /opt/crypto-lab/shared/server.py
```

The password is stored in MD5 format.  Let's try reversing it using John the Ripper.

First, copy the hash file to your local machine.

*From your local machine (not the remote EC2 instance):*
```bash
you@local-machine:~$ scp crypto-lab-student:/opt/crypto-lab/shared/password4.db .
```

Then, reverse the MD5 hash.

*From your local machine (not the remote EC2 instance):*
```bash
you@local-machine:~$ john --format=raw-md5 password4.db
```


### Password

```
bcrypt is the best (current) method for password storage
```
