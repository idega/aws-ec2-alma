#!/bin/bash
set_aws_ec2_admin_user_password() {
    local password=$(date | base64)
    echo $password | sudo passwd $AWS_EC2_INSTANCE_ADMIN_USERNAME --stdin
}

sudo useradd $AWS_EC2_INSTANCE_ADMIN_USERNAME
echo "$AWS_EC2_INSTANCE_ADMIN_USERNAME ALL=(ALL) NOPASSWD:ALL" | sudo tee --append /etc/sudoers