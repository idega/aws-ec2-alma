#!/bin/bash
function copy_iw_tomcat_server_update_script() {
    sudo cp ../../../../opt/app/tomcat/bin/update.sh /opt/$1/tomcat/bin/
    sudo chown $1:$1 /opt/$1/tomcat/bin/update.sh
    sudo chmod go-rwx /opt/$1/tomcat/bin/update.sh
    sudo restorecon -F -R /opt/$1/tomcat/bin/update.sh
}
