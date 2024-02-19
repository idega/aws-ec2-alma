#!/bin/bash
function restore_iw_service_last_backup() {
    local service_user_home=/opt/$1/
    local tomcat_home=/opt/$1/tomcat/
    local yesterday=$(date +%Y-%m-%d -d "0 days ago");
    local backup_link=s3://ec2-backup-$2/$yesterday
    local backup_folder=$HOME/Restore/$1
    local iw_service_db_import_template_path=../sql/import_iw_tomcat_service_db.template.sql
    local iw_service_db_import_file_path=../sql/import_iw_tomcat_service_db.$1.sql

    export IW_SERVICE_DB_RESTORE_FILE_PATH=$backup_folder/$yesterday/database.sql

    echo "Downloading..."
    mkdir -p $backup_folder
    s3cmd get --recursive --skip-existing $backup_link $backup_folder

    echo "Extracting..."
    local sql_archive_path=$(find $backup_folder/ -name "*.sql.gz")
    gunzip -c $sql_archive_path > $IW_SERVICE_DB_RESTORE_FILE_PATH

    local server_archive_path=$(find $backup_folder/ -name "*.tar.gz")
    tar -xvf $server_archive_path --skip-old-files -C $backup_folder/$yesterday/

    echo "Creating database import file..."
    envsubst '$IW_SERVICE_DB_RESTORE_FILE_PATH' < $iw_service_db_import_template_path > $iw_service_db_import_file_path

    echo "Importing database for $1 user..."
    mysql -u root -D $1 -p < $iw_service_db_import_file_path

    local current_jcr_store_folder_path=$(sudo find $tomcat_home/ -name "*store")
    echo "$current_jcr_store_folder_path"
    if [ -d $current_jcr_store_folder_path ]; then
        sudo mv $current_jcr_store_folder_path $current_jcr_store_folder_path.$(date +%Y-%m-%d)
    fi;

    local jcr_store_folder_path=$(find $backup_folder/$yesterday/ -name "*store")
    if [ -d $jcr_store_folder_path ]; then
        echo "Moving store folder $jcr_store_folder_path..."
        sudo mv $jcr_store_folder_path $tomcat_home
        sudo restorecon -F -R $tomcat_home
        sudo chown -R $1:$1 $tomcat_home
    else
        echo "Store folder does not exist in archive"
    fi
}