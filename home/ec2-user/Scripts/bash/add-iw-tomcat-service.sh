#!/bin/bash
#
# Functions
#
source variables/export.sh
source tomcat/function/download_iw_database_driver.sh
source tomcat/function/download_iw_tomcat_server.sh
source tomcat/function/create_iw_tomcat_service_user.sh
source tomcat/function/create_iw_tomcat_service_update_script.sh
source tomcat/function/create_iw_tomcat_service_configuration.sh
source tomcat/function/create_iw_tomcat_service_root_configuration.sh
source tomcat/function/create_link_to_iw_service.sh
source service/backup/function/create_iw_service_backup_script.sh
source maria/function/create_iw_service_database.sh
source nginx/function/create_iw_service_domain_configuration.sh
source admin/function/create_iw_admin_user.sh

# Tomcat service user
create_iw_tomcat_service_user $1

# Tomcat service
download_iw_tomcat_server $1
download_iw_database_driver $1
create_iw_tomcat_service_update_script $1
create_iw_tomcat_service_configuration $1

# Tomcat service database
export readonly IW_TOMCAT_SERVICE_DB_USER_NAME=$1
export readonly IW_TOMCAT_SERVICE_DB_PASSWORD=$(openssl rand -base64 32)

create_iw_tomcat_service_root_configuration $1

create_iw_service_database

create_iw_service_backup_script \
    $1 \
    $IW_TOMCAT_SERVICE_DB_USER_NAME \
    $IW_TOMCAT_SERVICE_DB_USER_NAME \
    $IW_TOMCAT_SERVICE_DB_PASSWORD

unset IW_TOMCAT_SERVICE_DB_USER_NAME
unset IW_TOMCAT_SERVICE_DB_PASSWORD

sudo systemctl enable $1

# Domain
create_iw_service_domain_configuration $2 $3

create_link_to_iw_service $1

# Certbot
sudo certbot --nginx