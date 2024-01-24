#!/bin/bash
function download_iw_database_driver() {
    local tomcat_installation_lib_dir=/opt/$1/tomcat/lib/

    # sudo -u $1 wget --directory-prefix $tomcat_installation_lib_dir $IW_MARIA_JDBC_DRIVER_URL
    # sudo -u $1 wget --directory-prefix $tomcat_installation_lib_dir $IW_JDBC_DRIVER_WRAPPER_URL
    # sudo chmod -R go-rwx $tomcat_installation_lib_dir
    # sudo restorecon -F -R $tomcat_installation_lib_dir

    ln -s /usr/lib/java/mariadb-java-client.jar $tomcat_installation_lib_dir
}