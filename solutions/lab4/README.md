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

See [solution.py](solution.py) for example implementation of such a timing attack.


### Password

```
Hashes4Life
```
