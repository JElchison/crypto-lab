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

* *Supports many students*:  One Docker host serves all students in the lab simultaneously
* *Dockerized*:  Each of the 4 lab servers (and their corresponding clients) run in their own Docker instance (that's 8 instances total)
* *Easy installation*:  Single Bash script to prepare the lab environment ([`install.sh`](install.sh))
* *Easy launch*:  Single Bash script to (re)launch all 8 Docker instances ([`start.sh`](start.sh)).  Can be re-run to relaunch all services.
* *Cloud-capable*:  Designed to be hosted on an EC2 instance.  However, it can also be run local and/or virtualized.


# Environment

The entire lab can be hosted on a single Ubuntu machine, network-reachable by lab students.

This machine should be Ubuntu-based, and only needs tcp/22 open for SSH.

Two users are utilized on the Ubuntu machine:

1. Whatever user you run [`start.sh`](start.sh) as.  On the EC2 instance, this is the `ubuntu` user.  To avoid spoling the challenge, students in the lab should not have access to this user's home directory.  This user should be a sudoer.
2. A new `student` user, created by [`install.sh`](install.sh).  All students in the lab will utilize this user.  This user should *not* be a sudoer, but should be able to `sudo tcpdump`.


# Installation


