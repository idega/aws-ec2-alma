#!/bin/bash
export readonly AWS_EC2_INSTANCE_ADMIN_USERNAME=idegaweb

# SFTP
export readonly AWS_EC2_INSTANCE_SFTP_GROUP_NAME=sftp
export readonly AWS_EC2_INSTANCE_SFTP_DIRECTORY=/var/local/$AWS_EC2_INSTANCE_SFTP_GROUP_NAME

# Service users
declare -arx AWS_EC2_INSTANCE_SERVICE_USER_NAMES=('camunda' 'gulur' 'munizapp')