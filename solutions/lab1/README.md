# lab1 Solution

### Steps

*From the remote EC2 instance (*not* your local machine):*
```bash
```bash
# see what processes are using port 5001
ps ax | grep 5001

# take a closer look at the python script using port 5001
less /opt/crypto-lab/shared/server.py

# password is stored in bcrypt format.  shucks.
# however, the Flask application is serving plain HTTP, which is subject to sniffing.

# there is sample client traffic being sent to the server, so let's inspect the traffic
sudo tcpdump -A -i docker0 tcp port 5001 | grep password=
```


### Password

```
Always_use_TLS
```
