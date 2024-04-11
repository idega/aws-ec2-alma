#!/bin/bash
s3cmd get $AWS_S3_JDK_INSTALLATION_PATH
sudo rpm -ivh --nodigest --nofiledigest $AWS_S3_JDK_INSTALLATION_FILE_NAME
rm -f $AWS_S3_JDK_INSTALLATION_FILE_NAME
sudo update-alternatives --config java