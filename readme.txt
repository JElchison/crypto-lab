1. sniff plain-text password from web traffic
    * HINT:  tcpdump on [interface]
    * ACTUAL STEPS:
        netstat -npl | grep 5000
        ps ax | grep python
        cat server.py
        sudo tcpdump -A -i [interface] tcp port 5000 | grep password=
    * LEARN:  Always use TLS
    * FLAG:  Always_use_TLS
    
2. scrape password from file
    * HTTPS POST login, repeated every 30s from localhost (red herring)
    * password stored in plain-text in file in /home/student/password.txt
    * HINT:  You'll have no luck with HTTPS
    * LEARN:  Always store passwords hashed and salted (never plain-text)
    * FLAG:  Always store passwords hashed and salted (never plain-text)

3. attack timing of password checking
    * password stored in plain-text in file in /home/ubuntu/
    * HINT:  How long does it take?
    * LEARN:  Always compare password hashes using constant-time comparison
    * FLAG:  Always compare password hashes using constant-time comparison
    
4. reverse password hash in file
    * password stored in plain-text in file in /home/student/hash.txt unsalted with MD5("password1")
        * john --format=raw-md5 /home/student/hash.txt
    * HINT:  John the Ripper
    * LEARN:  bcrypt is the best (current) method for password storage
    * FLAG:  bcrypt is the best (current) method for password storage
    
======

2 users

ubuntu = teacher
    * can sudo

student
    * cannot sudo
    * can access tcpdump interface (https://askubuntu.com/questions/530920/tcpdump-permissions-problem)
