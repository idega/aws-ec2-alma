#!/bin/bash
sudo firewall-cmd --set-default-zone=drop
sudo firewall-cmd --add-service ssh
sudo firewall-cmd --add-service ssh --permanent
sudo firewall-cmd --add-service http
sudo firewall-cmd --add-service http --permanent
sudo firewall-cmd --add-service https
sudo firewall-cmd --add-service https --permanent
sudo firewall-cmd --add-port 8080-8099/tcp
sudo firewall-cmd --add-port 8080-8099/tcp --permanent
