#!/bin/bash
function create_iw_tomcat_service_configuration() {
local tomcat_service_configuration_file=/usr/lib/systemd/system/$1.service

sudo rm -f $tomcat_service_configuration_file
sudo touch $tomcat_service_configuration_file
cat << EOF | sudo tee --append $tomcat_service_configuration_file
[Unit]
Description=Webapp
After=network.target

[Service]
Type=forking

User=$1
Group=$1

Environment="JAVA_HOME=/usr/java/latest"
Environment="JAVA_OPTS=-Djava.security.egd=file:///dev/urandom"
Environment="CATALINA_BASE=/opt/$1/tomcat"
Environment="CATALINA_HOME=/opt/$1/tomcat"
Environment="CATALINA_PID=/opt/$1/tomcat/temp/tomcat.pid"
Environment="CATALINA_OPTS=-Xms1G -Xmx2G -server -XX:+UseParallelGC -Dhibernate.search.default.indexBase=/opt/$1/tomcat/"

ExecStart=/opt/$1/tomcat/bin/update.sh
ExecStop=/opt/$1/tomcat/bin/shutdown.sh

[Install]
WantedBy=multi-user.target
EOF

sudo restorecon -F $tomcat_service_configuration_file
sudo systemctl daemon-reload

# sepolicy generate --init /usr/local/bin/$1
}
