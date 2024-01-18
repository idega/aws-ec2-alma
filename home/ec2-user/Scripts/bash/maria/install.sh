#!/bin/bash
sudo yum -y install \
    mariadb.x86_64 \
    mariadb-common.x86_64 \
    mariadb-server.x86_64 \
    mariadb-server-utils.x86_64 \
    mariadb-java-client.noarch \
    mariadb-pam.x86_64
sudo systemctl enable mariadb;
sudo systemctl restart mariadb;