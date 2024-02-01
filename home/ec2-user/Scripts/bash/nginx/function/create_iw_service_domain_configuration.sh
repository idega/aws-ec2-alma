#!/bin/bash
function create_iw_service_domain_configuration() {
    export readonly IW_APP_DOMAIN=$1
    export readonly IW_APP_PORT=$2
    local iw_app_ui_path=/var/www/html/$IW_APP_DOMAIN
    local iw_app_conf_path=/etc/nginx/conf.d/$IW_APP_DOMAIN.conf

    sudo mkdir -p $iw_app_ui_path
    sudo chown nginx:nginx $iw_app_ui_path
    sudo restorecon -F -R $iw_app_ui_path

    envsubst '$IW_APP_DOMAIN,$IW_APP_PORT' < $IW_ALMA_CONFIGURATION_HOME/etc/nginx/conf.d/nginx.template.conf > $IW_ALMA_CONFIGURATION_HOME$iw_app_conf_path
    sudo mv $IW_ALMA_CONFIGURATION_HOME$iw_app_conf_path $iw_app_conf_path
    sudo chown root:root $iw_app_conf_path
    sudo restorecon -F -R $iw_app_conf_path

    echo "127.0.0.1 $IW_APP_DOMAIN" | sudo tee --append /etc/hosts

    unset IW_APP_DOMAIN
    unset IW_APP_PORT

    sudo systemctl restart nginx
}