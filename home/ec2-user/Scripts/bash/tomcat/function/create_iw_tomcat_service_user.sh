#!/bin/bash
function create_iw_tomcat_service_user() {
    local sftp_directory=$AWS_EC2_INSTANCE_SFTP_DIRECTORY/$1
    local wars_directory=$AWS_EC2_INSTANCE_SFTP_DIRECTORY/$1/wars

    # User
    sudo useradd \
        --home-dir /opt/$1 \
        --shell /sbin/nologin $1

    # Group
    sudo usermod -aG $AWS_EC2_INSTANCE_SFTP_GROUP_NAME $1

    # Password
    local password=$(date | base64)
    echo $password | sudo passwd $1 --stdin

    # SSH access
    sudo cp -r $HOME/.ssh /opt/$1/
    sudo chown -R $1:$1 /opt/$1/.ssh
    sudo restorecon -F -R /opt/$1/.ssh

    # SFTP directory
    sudo mkdir -p $wars_directory
    sudo chown $1:$AWS_EC2_INSTANCE_SFTP_GROUP_NAME $wars_directory
    sudo chown root:$AWS_EC2_INSTANCE_SFTP_GROUP_NAME $sftp_directory
    sudo chmod -R o+rx $sftp_directory
    sudo restorecon -F -R $sftp_directory
}
