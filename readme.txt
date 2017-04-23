Setup local ~/.ssh/config
    Host crypto-lab
        IdentityFile ~/.ssh/xxxxxxxx.pem
        HostName xxxxxxxx.compute-1.amazonaws.com
        User ubuntu

On EC2 instance
* Latest Ubuntu
    * Name key pair 'crypto-lab'
    * tcp/22 only open port
* git clone https://github.com/JElchison/crypto-lab.git
* sudo crypto-lab/install.sh.  Look for 'Success' message.
* sudo crypto-lab/start.sh.  Look for 'Success' message.
* copy student SSH key to local
    * ssh crypto-lab sudo cp /home/student/.ssh/crypto-lab-student .
    * ssh crypto-lab sudo chown ubuntu: crypto-lab-student
    * scp crypto-lab:crypto-lab-student ~/.ssh/
    * ssh crypto-lab rm -fv crypto-lab-student
* disseminate to students tarfile:
    * ~/.ssh/config
        Host crypto-lab-student
            IdentityFile ~/.ssh/crypto-lab-student
            HostName xxxxxxxx.compute-1.amazonaws.com
            User student
    * ~/.ssh/student (from above)
        * along with selected passphrase
    * ~/connect.sh
* instruct students
    * ~/connect.sh
        ssh -nNTv -L 5001:localhost:5001 -L 5002:localhost:5002 -L 5003:localhost:5003 -L 5004:localhost:5004 crypto-lab-student
        * local ports 5001-5004
        * http://localhost:5001/
    * ssh crypto-lab
