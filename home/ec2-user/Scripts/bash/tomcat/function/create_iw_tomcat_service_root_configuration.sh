#!/bin/bash
function create_iw_tomcat_service_root_configuration() {
    local iw_root_template_path=$IW_SCRIPT_CONF_DIR/opt/app/tomcat/conf/Catalina/localhost/ROOT.template.xml
    local iw_root_file_path=$IW_SCRIPT_CONF_DIR/opt/$1/tomcat/conf/Catalina/localhost/ROOT.xml
    local iw_tomcat_service_catalina_path=/opt/$1/tomcat/conf/Catalina/localhost/ROOT.xml

    envsubst '$IW_TOMCAT_SERVICE_DB_USER_NAME,$IW_TOMCAT_SERVICE_DB_PASSWORD' < $iw_root_template_path > $iw_root_file_path
    
    sudo mv $iw_root_file_path $iw_tomcat_service_catalina_path
    sudo chown $1:$1 $iw_tomcat_service_catalina_path
    sudo restorecon -F -R $iw_tomcat_service_catalina_path
}