#!/bin/bash
function copy_iw_tomcat_server_update_script() {
    local tomcat_service_update_file_path=/opt/$1/tomcat/bin/update.sh
    sudo cp ../../../../opt/app/tomcat/bin/update.sh $tomcat_service_update_file_path
    sudo chown $1:$1 $tomcat_service_update_file_path
    sudo chmod +x $tomcat_service_update_file_path
    sudo chmod go-rwx $tomcat_service_update_file_path
    sudo restorecon -F -R $tomcat_service_update_file_path
}
