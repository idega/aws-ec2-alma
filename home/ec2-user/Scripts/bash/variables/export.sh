#!/bin/bash
export IW_SCRIPT_CONF_DIR=$(builtin cd "../../../../"; pwd)

export readonly AWS_EC2_INSTANCE_ADMIN_USERNAME=idegaweb

# SFTP
export readonly AWS_EC2_INSTANCE_SFTP_GROUP_NAME=sftp
export readonly AWS_EC2_INSTANCE_SFTP_DIRECTORY=/var/local/$AWS_EC2_INSTANCE_SFTP_GROUP_NAME

# S3
export readonly AWS_S3_JDK_INSTALLATION_FILE_NAME=jdk-8u251-linux-x64.rpm
export readonly AWS_S3_JDK_INSTALLATION_PATH=s3://aws-ec2-instance-setup/jdk/$AWS_S3_JDK_INSTALLATION_FILE_NAME

# Tomcat services
export readonly IW_TOMCAT_DOWNLOAD_URL="https://archive.apache.org/dist/tomcat/tomcat-7/v7.0.99/bin/apache-tomcat-7.0.99.tar.gz"
export readonly IW_TOMCAT_INSTALLATION_ARCHIVE="apache-tomcat-7.0.99.tar.gz"
export readonly IW_TOMCAT_INSTALLATION_NAME=apache-tomcat-7.0.99

# JDBC
export readonly IW_MARIA_JDBC_DRIVER_URL=https://dlm.mariadb.com/3700566/Connectors/java/connector-java-3.3.2/mariadb-java-client-3.3.2.jar

# C3P0
export readonly IW_JDBC_DRIVER_WRAPPER_URL=https://repo1.maven.org/maven2/com/mchange/c3p0/0.9.5.5/c3p0-0.9.5.5.jar

# Service users
declare -arx IW_TOMCAT_SERVICE_USER_NAMES=('camunda' 'gulur' 'munizapp')

declare -A IW_TOMCAT_SERVICE_DOMAIN;
IW_TOMCAT_SERVICE_DOMAIN[camunda]=camunda.idega.org
IW_TOMCAT_SERVICE_DOMAIN[gulur]=gulur.idega.org
IW_TOMCAT_SERVICE_DOMAIN[munizapp]=munizapp.idega.org

declare -A IW_TOMCAT_SERVICE_PORT;
IW_TOMCAT_SERVICE_PORT[camunda]=8080
IW_TOMCAT_SERVICE_PORT[gulur]=8081
IW_TOMCAT_SERVICE_PORT[munizapp]=8082
