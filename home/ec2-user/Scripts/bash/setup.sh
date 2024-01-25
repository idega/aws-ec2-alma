#!/bin/bash
source variables/export.sh
source service/user/function/set_aws_ec2_instance_service_user.sh
source tomcat/function/download_iw_database_driver.sh
source tomcat/function/download_iw_tomcat_server.sh
source tomcat/function/copy_iw_tomcat_server_update_script.sh
source tomcat/function/create_iw_tomcat_service_configuration.sh
source tomcat/function/create_iw_tomcat_service_root_configuration.sh
source maria/function/create_iw_service_database.sh
source nginx/function/copy_iw_app_nginx_configuration.sh
source service/backup/function/create_iw_service_backup_script.sh

#
# Software installation
#
./tools/install.sh
./firewall/install.sh
./maria/install.sh
./s3/install.sh
./jdk/install.sh
./ldap/install.sh
./nginx/install.sh
./openscap/install.sh

#
# Software configuration
#
./firewall/configure.sh
./sftp/configure.sh
./s3/configure.sh
./ldap/configure.sh
./maria/configure.sh
./nginx/configure.sh
./tomcat/configure.sh

#
# Users
#
./admin/create.sh

for iw_tomcat_service_user_name in "${IW_TOMCAT_SERVICE_USER_NAMES[@]}"; do 

    # Tomcat service user
    set_aws_ec2_instance_service_user $iw_tomcat_service_user_name

    # Tomcat service
    download_iw_tomcat_server $iw_tomcat_service_user_name
    download_iw_database_driver $iw_tomcat_service_user_name
    copy_iw_tomcat_server_update_script $iw_tomcat_service_user_name
    create_iw_tomcat_service_configuration $iw_tomcat_service_user_name
    sudo systemctl enable $iw_tomcat_service_user_name

    # MySQL database
    export readonly IW_TOMCAT_SERVICE_DB_USER_NAME=$iw_tomcat_service_user_name
    export readonly IW_TOMCAT_SERVICE_DB_PASSWORD=$(openssl rand -base64 32)
    create_iw_service_database
    create_iw_tomcat_service_root_configuration $iw_tomcat_service_user_name
    create_iw_service_backup_script \
        $iw_tomcat_service_user_name \
        $IW_TOMCAT_SERVICE_DB_USER_NAME \
        $IW_TOMCAT_SERVICE_DB_USER_NAME \
        $IW_TOMCAT_SERVICE_DB_PASSWORD
    unset IW_TOMCAT_SERVICE_DB_USER_NAME
    unset IW_TOMCAT_SERVICE_DB_PASSWORD

    # Tomcat domain
    copy_iw_app_nginx_configuration $iw_tomcat_service_user_name

    # Certbot
    sudo certbot --nginx
done

#
# Securing
# 
./openscap/remediate.sh