#!/bin/bash
function install_iw_app_war_file() {
    local iw_tomcat_home_dir=/opt/$1/tomcat
    local iw_service_user_sftp_dir=/var/local/sftp/$1/wars

    echo "Backing up"
    tar -cvf $iw_tomcat_home_dir/webapps.$(date +%Y-%m-%d).tar.gz $iw_tomcat_home_dir/webapps

    for iw_war_file_path in $(ls $iw_service_user_sftp_dir/*.war); do
        if [ -f "$iw_war_file_path" ]; then
            iw_war_file_name="$(basename "$iw_war_file_path" .war)"
            echo "Processing update for $iw_war_file_name ...";

            echo "Removing old WAR... "
            rm -rf $iw_tomcat_home_dir/webapps/$iw_war_file_name*

            echo "Extracting $iw_war_file_path file..."
            unzip $iw_war_file_path -d $iw_tomcat_home_dir/webapps/$iw_war_file_name

            echo "Removing $iw_war_file_path file..."
            rm -f $iw_war_file_path
        fi
    done

    echo "Touching files..."
    find $iw_tomcat_home_dir/webapps/ -type f -exec touch {} +

    echo "Restoring reading rights..."
    chown -R $1:$1 $iw_tomcat_home_dir/webapps/
    restorecon -F -R $iw_tomcat_home_dir/webapps/
}

install_iw_app_war_file $(id -un)
./opt/$(id -un)/tomcat/bin/startup.sh
