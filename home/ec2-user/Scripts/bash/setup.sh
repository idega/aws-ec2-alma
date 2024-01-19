#!/bin/bash
source variables/export.sh
source service/user/function/set_aws_ec2_instance_service_user.sh
source tomcat/function/download_iw_tomcat_server.sh
source tomcat/function/copy_iw_tomcat_server_update_script.sh
source tomcat/function/create_iw_tomcat_service_configuration.sh

#
# Software installation
#
./tools/install.sh
./firewall/install.sh
./s3/install.sh
./jdk/install.sh
./ldap/install.sh
./openscap/install.sh

#
# Software configuration
#
./firewall/configure.sh
./sftp/configure.sh
./s3/configure.sh
./ldap/configure.sh

#
# Users
#
./admin/create.sh

for iw_tomcat_service_user_name in "${IW_TOMCAT_SERVICE_USER_NAMES[@]}"; do 
    set_aws_ec2_instance_service_user $iw_tomcat_service_user_name
done

#
# Tomcat
#
for iw_tomcat_service_user_name in "${IW_TOMCAT_SERVICE_USER_NAMES[@]}"; do 
    download_iw_tomcat_server $iw_tomcat_service_user_name
    copy_iw_tomcat_server_update_script $iw_tomcat_service_user_name
    create_iw_tomcat_service_configuration $iw_tomcat_service_user_name
done

sudo setsebool tomcat_can_network_connect_db on
sudo setsebool -P tomcat_can_network_connect_db on

#
# Securing
# 
./openscap/remediate.sh