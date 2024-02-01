#!/bin/bash
function create_iw_tomcat_service_update_script() {
    local tomcat_service_update_file_path=/opt/$1/tomcat/bin/update.sh
    sudo cp $IW_ALMA_CONFIGURATION_HOME/opt/app/tomcat/bin/update.sh $tomcat_service_update_file_path
    sudo chown $1:$1 $tomcat_service_update_file_path
    sudo chmod +x $tomcat_service_update_file_path
    sudo chmod go-rwx $tomcat_service_update_file_path
    sudo restorecon -F -R $tomcat_service_update_file_path
}
