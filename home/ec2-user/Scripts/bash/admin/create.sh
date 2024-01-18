#!/bin/bash
function set_aws_ec2_admin_user_password() {
    local password=$(date | base64)
    echo $password | sudo passwd $1 --stdin
}

function set_aws_ec2_instance_admin_user_ssh_access() {
    sudo cp -r $HOME/.ssh /home/$1/
    sudo chown -R $1:$1 /home/$1/.ssh
    sudo restorecon -F -R /home/$1/.ssh
}

sudo useradd $AWS_EC2_INSTANCE_ADMIN_USERNAME
set_aws_ec2_admin_user_password $AWS_EC2_INSTANCE_ADMIN_USERNAME
echo "$AWS_EC2_INSTANCE_ADMIN_USERNAME ALL=(ALL) NOPASSWD:ALL" | sudo tee --append /etc/sudoers