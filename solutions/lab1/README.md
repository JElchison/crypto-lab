# lab1 Solution

### Steps

See what processes are using port 5001.

*From the lab server (not your local machine):*
```bash
student@crypto-lab:~$ ps ax | grep 5001
```

Take a closer look at the python script using port 5001.

*From the lab server (not your local machine):*
```bash
student@crypto-lab:~$ less /opt/crypto-lab/shared/server.py
```

The password is stored in bcrypt format.  Shucks.

However, the Flask application is serving plain HTTP, which is subject to sniffing.

There is sample client traffic being sent to the server, so let's inspect the traffic.

*From the lab server (not your local machine):*
```bash
student@crypto-lab:~$ sudo tcpdump -A -i docker0 tcp port 5001 | grep password=
```


### Password

```
Always_use_TLS
```
