#!/bin/bash
function create_iw_service_backup_script() {
    export readonly iw_service_name=$1
    export readonly iw_db_name=$2
    export readonly iw_db_user_name=$3
    export readonly iw_db_user_pass=$4
    export readonly iw_service_domain=${IW_TOMCAT_SERVICE_DOMAIN[$1]}

    local iw_backup_template_path=$IW_ALMA_CONFIGURATION_HOME/opt/app/backup_iw_service.template.sh
    local iw_backup_generated_script_path=$IW_ALMA_CONFIGURATION_HOME/home/ec2-user/Scripts/bash/service/backup/backup_iw_service.$iw_service_name.sh
    local iw_backup_script_path=/root/Scripts/backup_iw_service.$iw_service_name.sh

    envsubst '$iw_service_name,$iw_service_domain,$iw_db_name,$iw_db_user_name,$iw_db_user_pass' < $iw_backup_template_path > $iw_backup_generated_script_path

    sudo mkdir -p /root/Scripts
    sudo chown -R root:root /root/Scripts
    sudo restorecon -F -R /root/Scripts

    sudo mv $iw_backup_generated_script_path $iw_backup_script_path
    sudo chown root:root $iw_backup_script_path
    sudo chmod +x $iw_backup_script_path
    sudo chmod o-rwx $iw_backup_script_path
    sudo restorecon -F -R $iw_backup_script_path

    unset iw_service_name;
    unset iw_db_name;
    unset iw_db_user_name;
    unset iw_db_user_pass;
    unset iw_service_domain;
}