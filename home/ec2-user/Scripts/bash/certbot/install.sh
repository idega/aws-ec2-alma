#!/bin/bash
sudo yum -y install certbot python3-certbot-nginx
echo "30 4 1 * * root certbot renew" | sudo tee --append /etc/crontab