#!/bin/bash
function create_iw_admin_user() {
    sudo useradd $1

    local password=$(date | base64)
    echo $password | sudo passwd $1 --stdin

    sudo cp -r $HOME/.ssh /home/$1/
    sudo chown -R $1:$1 /home/$1/.ssh
    sudo restorecon -F -R /home/$1/.ssh
    sudo chage -M 3650 $1 # 10 years for STIG

    echo "$1 ALL=(ALL) NOPASSWD:ALL" | sudo tee --append /etc/sudoers
}
