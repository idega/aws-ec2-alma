#!/bin/bash
function create_link_to_iw_service() {
    sudo chmod o+rx /opt/$1/
    sudo chmod o+rx /opt/$1/tomcat/
    sudo chmod o+rx /opt/$1/tomcat/logs/

    sudo -u $IW_ADMIN_USERNAME ln -s /opt/$1/tomcat /home/$IW_ADMIN_USERNAME/Services/$1
}