#!/bin/bash
function copy_iw_app_nginx_configuration() {
    local iw_app_domain=${IW_TOMCAT_SERVICE_DOMAIN[$1]}
    local iw_app_port=${IW_TOMCAT_SERVICE_PORT[$1]}
    local iw_app_ui_path=/var/www/html/$iw_app_domain

    sudo mkdir -p $iw_app_ui_path
    sudo chown nginx:nginx $iw_app_ui_path
    sudo restorecon -F -R $iw_app_ui_path

    envsubstr < $IW_SCRIPT_CONF_DIR/etc/nginx/conf.d/nginx.template.conf > /etc/nginx/conf.d/$iw_app_domain.conf

    echo "127.0.0.1 $iw_app_domain" | sudo tee --append /etc/hosts

    sudo systemctl restart nginx
}