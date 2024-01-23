#!/bin/bash
function copy_iw_app_nginx_configuration() {
    export readonly IW_APP_DOMAIN=${IW_TOMCAT_SERVICE_DOMAIN[$1]}
    export readonly IW_APP_PORT=${IW_TOMCAT_SERVICE_PORT[$1]}
    local iw_app_ui_path=/var/www/html/$IW_APP_DOMAIN
    local iw_app_conf_path=/etc/nginx/conf.d/$IW_APP_DOMAIN.conf

    sudo mkdir -p $iw_app_ui_path
    sudo chown nginx:nginx $iw_app_ui_path
    sudo restorecon -F -R $iw_app_ui_path

    envsubst '$IW_APP_DOMAIN,$IW_APP_PORT' < $IW_SCRIPT_CONF_DIR/etc/nginx/conf.d/nginx.template.conf > $IW_SCRIPT_CONF_DIR$iw_app_conf_path
    sudo mv $IW_SCRIPT_CONF_DIR$iw_app_conf_path $iw_app_conf_path
    sudo chown root:root $iw_app_conf_path
    sudo restorecon -F -R $iw_app_conf_path

    echo "127.0.0.1 $IW_APP_DOMAIN" | sudo tee --append /etc/hosts

    sudo systemctl restart nginx
    unset IW_APP_DOMAIN
    unset IW_APP_PORT
}