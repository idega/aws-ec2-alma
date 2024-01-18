#!/bin/bash
function inialize_aws_ec2_instance_ldap_database() {
    sudo cp /usr/share/openldap-servers/DB_CONFIG.example /var/lib/ldap/DB_CONFIG
    sudo chown -R ldap:ldap /var/lib/ldap/*
    sudo restorecon -F -R /var/lib/ldap/*
    sudo systemctl enable slapd
    sudo systemctl restart slapd
}

function copy_aws_ec2_instance_ldap_configuration_files() {
    cp ../../../../etc/openldap/slapd.d/* /etc/openldap/slapd.d/
    chown ldap:ldap /etc/openldap/slapd.d/*.ldif 
    chmod go-rwx /etc/openldap/slapd.d/*.ldif 
    restorecon -F /etc/openldap/slapd.d/*.ldif
}

function set_aws_ec2_instance_ldap_admin_password() {
    local password=$(date | base64)
    local hash=$(slappasswd -s $password)
    sudo sed -i "s/olcRootPW: .*/olcRootPW: ${hash}/g" /etc/openldap/slapd.d/ldap.idega.is.ldif
    echo "LDAP administrator hash is: $hash"
    echo "LDAP administrator password is: $password"
}

function load_aws_ec2_instance_ldap_configuration() {
    ldapadd -Y EXTERNAL -H ldapi:/// -f /etc/openldap/schema/cosine.ldif
    ldapadd -Y EXTERNAL -H ldapi:/// -f /etc/openldap/schema/inetorgperson.ldif
    ldapadd -Y EXTERNAL -H ldapi:/// -f /etc/openldap/schema/nis.ldif
    ldapmodify -Y EXTERNAL -H ldapi:/// -f /etc/openldap/slapd.d/ldap.idega.is.ldif
    ldapmodify -Y EXTERNAL -H ldapi:/// -f /etc/openldap/slapd.d/domain.ldif;
    ldapadd -x -D cn=ldapadm,dc=ldap,dc=idega,dc=is -W -f /etc/openldap/slapd.d/base.ldif
}

inialize_aws_ec2_instance_ldap_database
copy_aws_ec2_instance_ldap_configuration_files
set_aws_ec2_instance_ldap_admin_password
load_aws_ec2_instance_ldap_configuration
