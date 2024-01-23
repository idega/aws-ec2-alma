CREATE DATABASE ${IW_TOMCAT_SERVICE_DB_USER_NAME};
CREATE USER '${IW_TOMCAT_SERVICE_DB_USER_NAME}@localhost' IDENTIFIED BY '${IW_TOMCAT_SERVICE_DB_PASSWORD}';
GRANT ALL PRIVILEGES ON ${IW_TOMCAT_SERVICE_DB_USER_NAME}.* TO '${IW_TOMCAT_SERVICE_DB_USER_NAME}@localhost';
COMMIT;