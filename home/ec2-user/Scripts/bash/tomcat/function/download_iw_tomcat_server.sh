#!/bin/bash
function download_iw_tomcat_server() {
    local tomcat_service_user_dir=/opt/$1
    local tomcat_installation_dir=/opt/$1/tomcat
    local tomcat_archive_dir=$tomcat_service_user_dir/$IW_TOMCAT_INSTALLATION_ARCHIVE
    local tomcat_extracted_archive_dir=$tomcat_service_user_dir/$IW_TOMCAT_INSTALLATION_NAME

    sudo -u $1 wget --directory-prefix $tomcat_service_user_dir $IW_TOMCAT_DOWNLOAD_URL
    sudo -u $1 tar -xvf $tomcat_archive_dir --directory $tomcat_service_user_dir
    sudo mv $tomcat_extracted_archive_dir $tomcat_installation_dir
    sudo chmod -R go-rwx $tomcat_installation_dir
    sudo restorecon -F -R $tomcat_installation_dir
    sudo rm -rf $tomcat_archive_dir
}