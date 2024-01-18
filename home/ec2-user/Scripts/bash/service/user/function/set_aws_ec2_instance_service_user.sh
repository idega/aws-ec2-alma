#!/bin/bash
function set_aws_ec2_service_user_password() {
    local password=$(date | base64)
    echo $password | sudo passwd $1 --stdin
}

function set_aws_ec2_instance_service_user_sftp_directory() {
    local user_directory=$AWS_EC2_INSTANCE_SFTP_DIRECTORY/$1
    local wars_directory=$AWS_EC2_INSTANCE_SFTP_DIRECTORY/$1/wars

    sudo mkdir -p $wars_directory
    sudo chown $1:$2 $wars_directory
    sudo chown root:$2 $user_directory
    sudo chmod -R o+rx $user_directory
    sudo restorecon -F -R $user_directory
}

function set_aws_ec2_instance_service_user_ssh_access() {
    sudo cp -r $HOME/.ssh /opt/$1/
    sudo chown -R $1:$1 /opt/$1/.ssh
    sudo restorecon -F -R /opt/$1/.ssh
}

export function set_aws_ec2_instance_service_user() {
    sudo useradd \
        --home-dir /opt/$aws_ec2_instance_service_user_name \
        --shell /sbin/nologin $aws_ec2_instance_service_user_name
    sudo usermod -aG $AWS_EC2_INSTANCE_SFTP_GROUP_NAME $aws_ec2_instance_service_user_name
    set_aws_ec2_service_user_password $aws_ec2_instance_service_user_name
    set_aws_ec2_instance_service_user_ssh_access $aws_ec2_instance_service_user_name
    set_aws_ec2_instance_service_user_sftp_directory $aws_ec2_instance_service_user_name $AWS_EC2_INSTANCE_SFTP_GROUP_NAME
}
