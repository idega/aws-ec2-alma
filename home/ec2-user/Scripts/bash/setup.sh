#!/bin/bash
source variables/export.sh
source service/user/function/set_aws_ec2_instance_service_user.sh
source tomcat/function/download_iw_tomcat_server.sh
source tomcat/function/copy_iw_tomcat_server_update_script.sh
source tomcat/function/create_iw_tomcat_service_configuration.sh
source nginx/function/copy_iw_app_nginx_configuration.sh

#
# Software installation
#
./tools/install.sh
./firewall/install.sh
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
    copy_iw_tomcat_server_update_script $iw_tomcat_service_user_name
    create_iw_tomcat_service_configuration $iw_tomcat_service_user_name
    sudo systemctl enable $iw_tomcat_service_user_name
    sudo systemctl restart $iw_tomcat_service_user_name

    # Tomcat domain
    copy_iw_app_nginx_configuration $iw_tomcat_service_user_name

    # Certbot
    sudo certbot --nginx
done

#
# Securing
# 
./openscap/remediate.sh