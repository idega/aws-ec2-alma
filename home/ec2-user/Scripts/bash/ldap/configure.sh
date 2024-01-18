#!/bin/bash
function inialize_aws_ec2_instance_ldap_database() {
    sudo cp /usr/share/openldap-servers/DB_CONFIG.example /var/lib/ldap/DB_CONFIG
    sudo chown -R ldap:ldap /var/lib/ldap/*
    sudo restorecon -F -R /var/lib/ldap/*
    sudo systemctl enable slapd
    sudo systemctl restart slapd
}

function copy_aws_ec2_instance_ldap_configuration_files() {
    sudo cp ../../../../etc/openldap/slapd.d/* /etc/openldap/slapd.d/
    sudo chown -R ldap:ldap /etc/openldap/slapd.d 
    sudo chmod -R go-rwx /etc/openldap/slapd.d
    sudo restorecon -R -F /etc/openldap/slapd.d/
}

function set_aws_ec2_instance_ldap_admin_password() {
    local password=$(date | base64)
    local hash=$(slappasswd -s $password)
    sudo sed -i "s/olcRootPW: .*/olcRootPW: ${hash}/g" /etc/openldap/slapd.d/ldap.idega.is.ldif
    echo "LDAP administrator password is: $password"
}

function load_aws_ec2_instance_ldap_configuration() {
    sudo ldapadd -Y EXTERNAL -H ldapi:/// -f /etc/openldap/schema/cosine.ldif
    sudo ldapadd -Y EXTERNAL -H ldapi:/// -f /etc/openldap/schema/inetorgperson.ldif
    sudo ldapadd -Y EXTERNAL -H ldapi:/// -f /etc/openldap/schema/nis.ldif
    sudo ldapmodify -Y EXTERNAL -H ldapi:/// -f /etc/openldap/slapd.d/ldap.idega.is.ldif
    sudo ldapmodify -Y EXTERNAL -H ldapi:/// -f /etc/openldap/slapd.d/domain.ldif;
    sudo ldapadd -x -D cn=ldapadm,dc=ldap,dc=idega,dc=is -W -f /etc/openldap/slapd.d/base.ldif
}

inialize_aws_ec2_instance_ldap_database
copy_aws_ec2_instance_ldap_configuration_files
set_aws_ec2_instance_ldap_admin_password
load_aws_ec2_instance_ldap_configuration
