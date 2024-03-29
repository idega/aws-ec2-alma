#!/bin/bash

#
# Disabling history of mysql client
#
rm -f $HOME/.mysql_history;
ln -s /dev/null $HOME/.mysql_history;

#
# Cloning default configuration
#
sudo systemctl stop mariadb
sudo cp $IW_ALMA_CONFIGURATION_HOME/etc/my.cnf.d/* /etc/my.cnf.d/
sudo restorecon -F /etc/my.cnf.d/*
sudo chmod o+r /etc/my.cnf.d/*
sudo chown root:root /etc/my.cnf.d/*

#
# Configuring limits
#
echo "mysql soft nofile 32768" | sudo tee --append /etc/security/limits.conf
echo "mysql hard nofile 32768" | sudo tee --append /etc/security/limits.conf
echo "LimitNOFILE=32768" | sudo tee --append /usr/lib/systemd/system/mariadb.service
echo "LimitNPROC=65535" | sudo tee --append /usr/lib/systemd/system/mariadb.service
sudo systemctl daemon-reload

#
# Cleaning intial configuration
#
sudo mysql_install_db --user=mysql
sudo restorecon -F -R /var/lib/mysql/
sudo rm -rf /var/lib/mysql/ib_logfile*
sudo service mariadb restart;

#
# Actual installation
#
sudo mysql_secure_installation;
