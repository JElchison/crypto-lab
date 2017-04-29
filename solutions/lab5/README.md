# lab5 Solution

### Steps

See what processes are using port 5005.

*From the lab server (not your local machine):*
```bash
student@crypto-lab:~$ ps ax | grep 5005
```

Take a closer look at the python script using port 5005.

*From the lab server (not your local machine):*
```bash
student@crypto-lab:~$ less /opt/crypto-lab/shared/server.py
```

The password is stored in MD5 format.  Let's try reversing it using John the Ripper (Jumbo community-enhanced version).

First, copy the hash file to your local machine.

*From your local machine (not the lab server):*
```bash
you@local-machine:~$ scp crypto-lab-student:/opt/crypto-lab/shared/password5.db .
```

Then, reverse the MD5 hash.

*From your local machine (not the lab server):*
```bash
you@local-machine:~$ john --format=raw-md5 password5.db
```


### Password

```
Password9
```
