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
