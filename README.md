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

* **Dockerized**:  Each of the 4 lab servers (and their corresponding clients) run in their own Docker instance (that's 8 instances total)
* **Supports many students**:  One Docker host serves all students in the lab simultaneously
* **Easy installation**:  Single Bash script to prepare the lab environment ([`install.sh`](install.sh))
* **Easy launch**:  Single Bash script to (re)launch all 8 Docker instances ([`start.sh`](start.sh)).  Can be re-run to relaunch all services.
* **Cloud-capable**:  Designed to be hosted on an EC2 instance.  However, it can also be run local and/or virtualized.


# Environment

The entire lab can be hosted on a single Ubuntu machine, network-reachable by lab students.  This machine should be Ubuntu-based, and only needs 22/tcp open for SSH.

Two users are utilized on the Ubuntu machine:

1. Whatever user you run [`start.sh`](start.sh) as.  On the EC2 instance, this is the `ubuntu` user.  To avoid spoling the challenge, students in the lab should not have access to this user's home directory.  This user should be a sudoer.
2. A new `student` user, created by [`install.sh`](install.sh).  All students in the lab will utilize this user.  This user should *not* be a sudoer, but should be able to `sudo tcpdump`.


# Setup

**1. Create an Ubuntu EC2 instance, preferably the latest Ubuntu Server LTS 64-bit**

* Last tested with `ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-20170221 (ami-f4cc1de2)`.
* No IAM role required
* Be sure to configure a Security Group that allows inbound SSH.  Everything else can be blocked.
* As part of the instance launch, cCreate a new SSH key pair, and name it `crypto-lab`.  Save `crypto-lab.pem` to your local `~/.ssh/`.

**2. Add a new entry to your `~/.ssh/config`, updating the HostName to point to your instance's Public DNS:**

```
Host crypto-lab
    User ubuntu
    HostName ec2-xxxxxxxxxxxx.compute-1.amazonaws.com
    IdentityFile ~/.ssh/crypto-lab.pem
```

You should now be able to `ssh crypto-lab` and be given a prompt as `ubuntu@crypto-lab`.

**3. SSH to the EC2 instance and install the lab server**

Clone this repo.  Ensure that you place it in the `ubuntu` user's home directory, out of reach of the students.

*From the remote EC2 instance (*not* your local machine):*
```bash
ubuntu@crypto-lab:~$ cd
ubuntu@crypto-lab:~$ git clone https://github.com/JElchison/crypto-lab.git
```

Run the installation script.

*From the remote EC2 instance (*not* your local machine):*
```bash
ubuntu@crypto-lab:~$ sudo crypto-lab/install.sh
```

When prompted, enter a passprase for the students' SSH key.  You may want this to be hard to guess, but easy to communicate verbally.  This key and passphrase will be the only way that your students can login to the lab server (i.e. login password is disabled).

Look for 'Success' message.

**4. Copy newly created `student` SSH key to your local machine**

*From your local machine (not the remote EC2 instance):*
```bash
you@local-machine:~$ ssh crypto-lab sudo cp /home/student/.ssh/crypto-lab-student .
you@local-machine:~$ ssh crypto-lab sudo chown ubuntu: crypto-lab-student
you@local-machine:~$ scp crypto-lab:crypto-lab-student ~/.ssh/
you@local-machine:~$ ssh crypto-lab rm -fv crypto-lab-student
```

**5. Add a new entry to your `~/.ssh/config`, updating the HostName to point to your instance's Public DNS:**

```
Host crypto-lab-student
    User student
    HostName ec2-xxxxxxxxxxxx.compute-1.amazonaws.com
    IdentityFile ~/.ssh/crypto-lab-student
```

You should now be able to `ssh crypto-lab-student` and be given a prompt as `student@crypto-lab`.

**6. SSH to the EC2 instance and start the lab server**

Run the start script.

*From the remote EC2 instance (*not* your local machine):*
```bash
ubuntu@crypto-lab:~$ sudo crypto-lab/start.sh
```

Look for 'Success' message.

**7. Prepare the distribution for students**

*From your local machine (not the remote EC2 instance):*
```bash
you@local-machine:~$ cp -fv solutions/lab3/lab3-template.py student-dist/lab3.py
you@local-machine:~$ cp -fv ~/.ssh/crypto-lab-student student-dist/.ssh/
```

Update the HostName to point to your instance's Public DNS.

*From your local machine (not the remote EC2 instance):*
```bash
you@local-machine:~$ vim student-dist/.ssh/config
```

Create the distributable file.

*From your local machine (not the remote EC2 instance):*
```bash
tar zvf student-dist.tgz -C student-dist/
```

**7. Distribute student-dist.tgz and your chosen passphrase to the students**


# Instructions for Students

Perform the following setup on your local machine:

```bash
tar xvf student-dist.tgz -C ~
chmod +x connect.sh
./connect.sh
```

At this point, you can treat ports 5001-5004 on your local machine as if they were on the remote lab server:

* Lab part 1:  TCP port 5001
* Lab part 2:  TCP port 5002
* Lab part 3:  TCP port 5003
* Lab part 4:  TCP port 5004

To get started with part 1, simply visit http://localhost:5001/ in a browser on your local machine.

To go interactive on the server:

```bash
ssh crypto-lab-student
```
