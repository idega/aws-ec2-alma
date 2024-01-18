#!/bin/bash
# Group
sudo groupadd $AWS_EC2_INSTANCE_SFTP_GROUP_NAME

# Directory
sudo mkdir -p $AWS_EC2_INSTANCE_SFTP_DIRECTORY
sudo chown root:root $AWS_EC2_INSTANCE_SFTP_DIRECTORY
sudo chmod o+rx $AWS_EC2_INSTANCE_SFTP_DIRECTORY
sudo restorecon -F $AWS_EC2_INSTANCE_SFTP_DIRECTORY

# SSHD
sudo sed -i 's/Subsystem sftp.*//g' /etc/ssh/sshd_config
sudo cp ../../../../etc/ssh/sshd_config.d/99-sftp.conf /etc/ssh/sshd_config.d/
sudo systemctl restart sshd