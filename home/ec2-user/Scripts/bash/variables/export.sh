#!/bin/bash
export readonly AWS_EC2_INSTANCE_ADMIN_USERNAME=idegaweb

# SFTP
export readonly AWS_EC2_INSTANCE_SFTP_GROUP_NAME=sftp
export readonly AWS_EC2_INSTANCE_SFTP_DIRECTORY=/var/local/$AWS_EC2_INSTANCE_SFTP_GROUP_NAME

# S3
export readonly AWS_S3_JDK_INSTALLATION_FILE_NAME jdk-8u251-linux-x64.rpm
export readonly AWS_S3_JDK_INSTALLATION_PATH s3://aws-ec2-instance-setup/jdk/$AWS_S3_JDK_INSTALLATION_FILE_NAME

# Service users
declare -arx AWS_EC2_INSTANCE_SERVICE_USER_NAMES=('camunda' 'gulur' 'munizapp')