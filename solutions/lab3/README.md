# lab3 Solution

### Steps

While student SSH'd into server:
```bash
# see what processes are using port 5003
ps ax | grep 5003

# take a closer look at the python script using port 5003
less /opt/crypto-lab/shared/server.py
```

Password is checked using a variable-time comparison.  We can infer how many correct characters at the beginning of our guess by watching the time the server takes to return.

See solution.py for example implementation of such a timing attack.


### Password

```
Always compare password hashes using constant-time comparison
```
