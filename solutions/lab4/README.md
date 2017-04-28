# lab4 Solution

### Steps

See what processes are using port 5004.

*From the lab server (not your local machine):*
```bash
student@crypto-lab:~$ ps ax | grep 5004
```

Take a closer look at the python script using port 5004.

*From the lab server (not your local machine):*
```bash
student@crypto-lab:~$ less /opt/crypto-lab/shared/server.py
```

The password is checked using a variable-time comparison.  We can infer how many correct characters at the beginning of our guess by watching the time the server takes to return.

Because of timing jitter, we should debounce and/or employ statistics.

See [solution.py](solution.py) for example implementation of such a timing attack.  This can be run from either your local machine or the lab server.


### Password

```
plzhash
```
