crypto-lab
==========

This repo embodies 4 separate cryptographic labs.  The goal in each of the 4 labs is to find the password.  All labs target a student new to cryptography, and the time goal for all labs is one hour.


# Topics

Following are some topics generally covered by these labs (in a random order):

* The woes of variable-time password comparisons (and how they can leak information)
* The woes of transmitting plaintext passwords in the clear (and how they can be sniffed)
* The woes of using outdated primitives (and how old hashing algorithms can be reversed)
* The woes of storing plaintext passwords in the clear (and how they can be stolen)


# Features

* **Supports many students**:  One Docker host serves all students in the lab simultaneously
* **Dockerized**:  Each of the 4 lab servers (and their corresponding clients) run in their own Docker instance (that's 8 instances total)
* **Easy installation**:  Single Bash script to prepare the lab environment ([`install.sh`](install.sh))
* **Easy launch**:  Single Bash script to (re)launch all 8 Docker instances ([`start.sh`](start.sh)).  Can be re-run to relaunch all services.
* **Cloud-capable**:  Designed to be hosted on an EC2 instance.  However, it can also be run local and/or virtualized.


# Environment

The entire lab can be hosted on a single Ubuntu machine, network-reachable by lab students.  This machine should be Ubuntu-based, and only needs tcp/22 open for SSH.

Two users are utilized on the Ubuntu machine:

1. Whatever user you run [`start.sh`](start.sh) as.  On the EC2 instance, this is the `ubuntu` user.  To avoid spoling the challenge, students in the lab should not have access to this user's home directory.  This user should be a sudoer.
2. A new `student` user, created by [`install.sh`](install.sh).  All students in the lab will utilize this user.  This user should *not* be a sudoer, but should be able to `sudo tcpdump`.


# Installation

1. Create an Ubuntu EC2 instance, preferably the latest Ubuntu Server LTS 64-bit
    * Last tested with `ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-20170221 (ami-f4cc1de2)`.
    * No IAM role required
    * Be sure to configure a Security Group that allows inbound SSH.  Everything else can be blocked.
    * Create a new SSH key pair, and name it `crypto-lab`.  Save `crypto-lab.pem` to your local `~/.ssh/`.

2. Add a new entry to your `~/.ssh/config`, updating the HostName to point to your instance's Public DNS:
```
Host crypto-lab
    User ubuntu
    HostName ec2-xxxxxxxxxxxx.compute-1.amazonaws.com
    IdentityFile ~/.ssh/crypto-lab.pem
```
You should now be able to `ssh crypto-lab` and be given a prompt as `ubuntu@crypto-lab`.

3. SSH to the EC2 instance
    * Clone this repo.  Ensure that you place it in the 'ubuntu' user's home directory, out of reach of the students.
```
ubuntu@crypto-lab:~$ cd
ubuntu@crypto-lab:~$ git clone https://github.com/JElchison/crypto-lab.git
```
    * Run the installation script.  Look for 'Success' message.
```
ubuntu@crypto-lab:~$ sudo crypto-lab/install.sh
```

4. Copy newly created 'student' SSH key to your local machine
```
you@local-machine:~$ ssh crypto-lab sudo cp /home/student/.ssh/crypto-lab-student .
you@local-machine:~$ ssh crypto-lab sudo chown ubuntu: crypto-lab-student
you@local-machine:~$ scp crypto-lab:crypto-lab-student ~/.ssh/
you@local-machine:~$ ssh crypto-lab rm -fv crypto-lab-student
```

5. Add a new entry to your `~/.ssh/config`, updating the HostName to point to your instance's Public DNS:
```
Host crypto-lab-student
    User student
    HostName ec2-xxxxxxxxxxxx.compute-1.amazonaws.com
    IdentityFile ~/.ssh/crypto-lab-student
```
You should now be able to `ssh crypto-lab-student` and be given a prompt as `student@crypto-lab`.

