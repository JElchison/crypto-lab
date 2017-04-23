* disseminate to students tarfile:
    * ~/.ssh/config
        Host crypto-lab-student
            IdentityFile ~/.ssh/crypto-lab-student
            HostName xxxxxxxx.compute-1.amazonaws.com
            User student
    * ~/.ssh/student (from above)
        * along with selected passphrase
    * ~/connect.sh
* sudo crypto-lab/start.sh.  Look for 'Success' message.
* instruct students
    * ~/connect.sh
        ssh -nNTv -L 5001:localhost:5001 -L 5002:localhost:5002 -L 5003:localhost:5003 -L 5004:localhost:5004 crypto-lab-student
        * local ports 5001-5004
        * http://localhost:5001/
    * ssh crypto-lab
