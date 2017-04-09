1. scrape plain-text password from web traffic
    * HINT:  tcpdump on [interface]
    * ACTUAL:
        netstat -npl | grep 5000
        ps ax | grep python
        cat server.py
        sudo tcpdump -A -i [interface] tcp port 5000 | grep password=
    * LEARN:  Always use TLS
    * FLAG:  [next port number]
    
2. scrape password from file
    * HTTPS POST login, repeated every 30s from localhost (red herring)
    * password stored in plain-text in file in /home/student/password.txt
    * HINT:  You'll have no luck with HTTPS
    * LEARN:  don't store plain-text passwords
    * FLAG:  [next port number]

3. attack timing of password checking
    * password stored in plain-text in file in /home/ubuntu/
    * HINT:  How long does it take?
    * LEARN:  non-constant-time password comparisons are bad
    * FLAG:  [next port number]
    
4. reverse password hash in file
    * password stored in plain-text in file in /home/student/hash.txt unsalted with MD5("password1")
        * john --format=raw-md5 /home/student/hash.txt
    * HINT:  John the Ripper
    * LEARN:  use bcrypt for password storage
    * FLAG:  bcrypt is the best crypt
    
======

2 users

ubuntu = teacher
    * can sudo

student
    * cannot sudo
    * can access tcpdump interface (https://askubuntu.com/questions/530920/tcpdump-permissions-problem)
