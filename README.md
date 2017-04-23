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

* Supports many students:  One Docker host serves all students in the lab simultaneously
* Dockerized:  Each of the 4 lab servers (and their corresponding clients) run in their own Docker instance (that's 8 instances total)
* Easy setup:  Single Bash script to launch all 8 Docker instances


# Environment

Entire lab can be hosted on a single Ubuntu machine, network-reachable by lab students.  Server can be physically local, virtualized, or in the cloud.  Lab was designed to run on an EC2 instance.


# Installation


