#!/bin/bash
function create_iw_service_database() {
    local iw_db_script_source_path=../sql/create_iw_tomcat_service_db.template.sql
    local iw_db_script_destination_path=../sql/create_iw_tomcat_service_db.$IW_TOMCAT_SERVICE_DB_USER_NAME.sql
    envsubst '$IW_TOMCAT_SERVICE_DB_USER_NAME,$IW_TOMCAT_SERVICE_DB_PASSWORD' < $iw_db_script_source_path > $iw_db_script_destination_path
    mysql -u root -p < $iw_db_script_destination_path
    rm -f $iw_db_script_destination_path
}