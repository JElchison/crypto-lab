1. sniff plain-text password from web traffic
    * HINT:  tcpdump on docker0
    * ACTUAL STEPS:
        ps ax | grep 5001
        less /opt/crypto-lab/shared/server.py
        tcpdump -A -i docker0 tcp port 5001 | grep password=
    * LEARN:  Always use TLS
    * FLAG :  Always_use_TLS
    
2. scrape password from file
    * HTTPS POST login, repeated every 30s from localhost (red herring)
    * password stored in plain-text in file in /home/student/password.txt
    * HINT:  You'll have no luck with HTTPS
    * ACTUAL STEPS:
        ps ax | grep 5002
        less /opt/crypto-lab/shared/server.py
        cat /opt/crypto-lab/shared/password2.db
    * LEARN:  Always store passwords hashed and salted (never plain-text)
    * FLAG   Always store passwords hashed and salted (never plain-text)

3. attack timing of password checking
    * password stored in plain-text in file in /home/ubuntu/
    * HINT:  How long does it take?
    * ACTUAL STEPS:
        TODO
    * LEARN:  Always compare password hashes using constant-time comparison
    * FLAG :  Always compare password hashes using constant-time comparison
    
4. reverse password hash in file
    * password stored in plain-text in file in /home/student/hash.txt unsalted with MD5("password1")
    * HINT:  John the Ripper
    * ACTUAL STEPS:
        scp /opt/crypto-lab/shared/password2.db
        john --format=raw-md5 password2.db
    * LEARN:  bcrypt is the best (current) method for password storage
    * FLAG :  bcrypt is the best (current) method for password storage
    
======

2 users

ubuntu = teacher
    * can sudo

student
    * cannot sudo
    * can access tcpdump interface (https://askubuntu.com/questions/530920/tcpdump-permissions-problem)
    
======

Setup local ~/.ssh/config
    Host crypto-lab
        IdentityFile ~/.ssh/xxxxxxxx.pem
        HostName xxxxxxxx.compute-1.amazonaws.com
        User ubuntu

On EC2 instance
* Latest Ubuntu
    * tcp/22 only open port
* git clone https://github.com/JElchison/crypto-lab.git
* sudo crypto-lab/start.sh
* copy student SSH key to local
    * ssh crypto-lab sudo cp /home/student/.ssh/student .
    * ssh crypto-lab sudo chown ubuntu: student
    * scp crypto-lab:student ~/.ssh/
    * ssh crypto-lab rm -fv student
* disseminate to students tarfile:
    * ~/.ssh/config
        Host crypto-lab
            IdentityFile ~/.ssh/student
            HostName xxxxxxxx.compute-1.amazonaws.com
            User student
    * ~/.ssh/student (from above)
        * along with selected passphrase
    * ~/connect.sh
* instruct students
    * ~/connect.sh
        ssh -nNTv -L 5001:localhost:5001 -L 5002:localhost:5002 -L 5003:localhost:5003 -L 5004:localhost:5004 crypto-lab
        * local ports 5001-5004
        * http://localhost:5001/
    * ssh crypto-lab
