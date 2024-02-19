SET autocommit=0;
SET foreign_key_checks=0;
SET unique_checks=0;

SOURCE ${IW_SERVICE_DB_RESTORE_FILE_PATH}

SET foreign_key_checks=1;
SET unique_checks=1;
COMMIT;
