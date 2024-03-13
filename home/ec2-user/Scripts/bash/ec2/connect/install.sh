#!/bin/bash
wget https://amazon-ec2-instance-connect-us-west-2.s3.us-west-2.amazonaws.com/latest/linux_amd64/ec2-instance-connect.rpm
wget https://amazon-ec2-instance-connect-us-west-2.s3.us-west-2.amazonaws.com/latest/linux_amd64/ec2-instance-connect-selinux.noarch.rpm
sudo yum install -y ec2-instance-connect.rpm
sudo yum install -y ec2-instance-connect-selinux.noarch.rpm
