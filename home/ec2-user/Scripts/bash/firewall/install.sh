#!/bin/bash
sudo yum install firewalld -y
sudo systemctl enable firewalld
sudo systemctl restart firewalld