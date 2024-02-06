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
source service/backup/function/create_iw_service_backup_script.sh
source maria/function/create_iw_service_database.sh
source nginx/function/create_iw_service_domain_configuration.sh
source admin/function/create_iw_admin_user.sh

#
# Packages
#
sudo yum -y install epel-release
sudo yum -y install \
    bc \
    certbot python3-certbot-nginx \
    elinks \
    firewalld \
    gettext \
    git \
    htop \
    mariadb.x86_64 mariadb-common.x86_64 mariadb-server.x86_64 mariadb-server-utils.x86_64 mariadb-java-client.noarch mariadb-pam.x86_64 \
    nginx \
    npm \
    openldap-servers.x86_64 openldap-clients.x86_64 openldap.x86_64 \
    openscap openscap-scanner openscap-utils \
    scap-security-guide \
    screen \
    s3cmd \
    vim \
    wget \
    unzip

#
# Services
#
sudo systemctl enable firewalld
sudo systemctl enable mariadb;
sudo systemctl enable nginx
sudo systemctl enable slapd

sudo systemctl restart firewalld
sudo systemctl restart mariadb;
sudo systemctl restart nginx
sudo systemctl restart slapd

#
# Service configuration
#
./s3/configure.sh
./firewall/configure.sh
./sftp/configure.sh
./ldap/configure.sh
./maria/configure.sh
./nginx/configure.sh
./jdk/install.sh

#
# SE Linux
#
sudo setsebool httpd_can_network_connect on
sudo setsebool -P httpd_can_network_connect on

sudo setsebool tomcat_can_network_connect_db on
sudo setsebool -P tomcat_can_network_connect_db on

#
# Cron
#
echo "30 4 1 * * root certbot renew" | sudo tee --append /etc/crontab

#
# Users
#
create_iw_admin_user $IW_ADMIN_USERNAME

#
# Applications
#
for iw_tomcat_service_user_name in "${IW_TOMCAT_SERVICE_USER_NAMES[@]}"; do 

    # Tomcat service user
    create_iw_tomcat_service_user $iw_tomcat_service_user_name

    # Tomcat service
    download_iw_tomcat_server $iw_tomcat_service_user_name
    download_iw_database_driver $iw_tomcat_service_user_name
    create_iw_tomcat_service_update_script $iw_tomcat_service_user_name
    create_iw_tomcat_service_configuration $iw_tomcat_service_user_name

    # Tomcat service database
    export readonly IW_TOMCAT_SERVICE_DB_USER_NAME=$iw_tomcat_service_user_name
    export readonly IW_TOMCAT_SERVICE_DB_PASSWORD=$(openssl rand -base64 32)

    create_iw_tomcat_service_root_configuration $iw_tomcat_service_user_name

    create_iw_service_database

    create_iw_service_backup_script \
        $iw_tomcat_service_user_name \
        $IW_TOMCAT_SERVICE_DB_USER_NAME \
        $IW_TOMCAT_SERVICE_DB_USER_NAME \
        $IW_TOMCAT_SERVICE_DB_PASSWORD

    unset IW_TOMCAT_SERVICE_DB_USER_NAME
    unset IW_TOMCAT_SERVICE_DB_PASSWORD

    sudo systemctl enable $iw_tomcat_service_user_name

    # Domain
    create_iw_service_domain_configuration ${IW_TOMCAT_SERVICE_DOMAIN[$iw_tomcat_service_user_name]} ${IW_TOMCAT_SERVICE_PORT[$iw_tomcat_service_user_name]}

    # Certbot
    sudo certbot --nginx
done

#
# Securing
# 
./openscap/remediate.sh