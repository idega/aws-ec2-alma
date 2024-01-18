#!/bin/bash
export AWS_EC2_INSTANCE_ADMIN_USERNAME=idegaweb

# SFTP
export AWS_EC2_INSTANCE_SFTP_GROUP_NAME=sftp
export AWS_EC2_INSTANCE_SFTP_DIRECTORY=/var/local/$AWS_EC2_INSTANCE_SFTP_GROUP_NAME

# Service users
export AWS_EC2_INSTANCE_SERVICE_USER_NAMES=('camunda' 'gulur' 'munizapp')