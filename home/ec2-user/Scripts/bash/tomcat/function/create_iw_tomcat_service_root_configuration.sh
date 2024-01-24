#!/bin/bash
function create_iw_tomcat_service_root_configuration() {
    local iw_root_template_path=$IW_SCRIPT_CONF_DIR/opt/app/tomcat/conf/Catalina/localhost/ROOT.template.xml
    local iw_root_folder_path=$IW_SCRIPT_CONF_DIR/opt/$1/tomcat/conf/Catalina/localhost
    local iw_tomcat_service_catalina_path=/opt/$1/tomcat/conf/Catalina/localhost/

    mkdir -p $iw_root_folder_path
    envsubst '$IW_TOMCAT_SERVICE_DB_USER_NAME,$IW_TOMCAT_SERVICE_DB_PASSWORD' < $iw_root_template_path > $iw_root_folder_path/ROOT.xml

    sudo mv $iw_root_folder_path/ROOT.xml $iw_tomcat_service_catalina_path
    sudo chown -R root:$1 $iw_tomcat_service_catalina_path
    sudo chmod -R o-rx $iw_tomcat_service_catalina_path
    sudo restorecon -F -R $iw_tomcat_service_catalina_path
}