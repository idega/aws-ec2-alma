#!/bin/bash
sudo yum -y install nginx certbot python3-certbot-nginx
sudo systemctl restart nginx
sudo systemctl enable nginx
sudo setsebool httpd_can_network_connect on
sudo setsebool -P httpd_can_network_connect on