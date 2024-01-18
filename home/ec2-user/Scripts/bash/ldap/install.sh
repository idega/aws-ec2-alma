#!/bin/bash
sudo yum -y install openldap-servers.x86_64 openldap-clients.x86_64 openldap.x86_64
sudo systemctl enable slapd
sudo systemctl restart slapds
