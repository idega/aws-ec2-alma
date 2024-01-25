#!/bin/bash

IW_SERVICE_BACKUP_FOLDER="$HOME/Backup/$iw_service_name/$(date +%Y-%m-%d)";

function create_iw_service_db_backup() {
    local iw_db_dump_file_path="$IW_SERVICE_BACKUP_FOLDER/db.sql.gz";

    mysqldump \
        -u $iw_db_user_name \
        -h 127.0.0.1 \
        --password=$iw_db_user_pass \
        --default-character-set=utf8 \
        --max_allowed_packet=1024M \
        --single-transaction $iw_db_name | gzip -9 > $iw_db_dump_file_path;
}

function create_iw_service_repo_backup() {
    local iw_repo_archive_path="$IW_SERVICE_BACKUP_FOLDER/repo.tar.gz";
    local iw_repo_path="/opt/$iw_service_name/tomcat/";

    sudo tar -zcf $iw_repo_archive_path $iw_repo_path;
}

mkdir -p $IW_SERVICE_BACKUP_FOLDER
create_iw_service_db_backup
create_iw_service_repo_backup
s3cmd put --recursive $IW_SERVICE_BACKUP_FOLDER/* "s3://ec2-backup-$iw_service_domain/$(date +%Y-%m-%d)/"
sudo rm -rf $IW_SERVICE_BACKUP_FOLDER
s3cmd del --recursive "s3://ec2-backup-$iw_service_domain/$(date +%Y-%m-%d -d "7 days ago")/"
