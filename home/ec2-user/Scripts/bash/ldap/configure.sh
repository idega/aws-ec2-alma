#!/bin/bash
function init_iw_ldap_service_db() {
    # sudo cp /usr/share/openldap-servers/DB_CONFIG.example /var/lib/ldap/DB_CONFIG
    sudo chown -R ldap:ldap /var/lib/ldap/*
    sudo restorecon -F -R /var/lib/ldap/*
    sudo systemctl enable slapd
    sudo systemctl restart slapd
}

function add_iw_ldap_service_conf() {
    local iw_conf_template_file=$IW_ALMA_CONFIGURATION_HOME/etc/openldap/slapd.d/$1
    local iw_conf_dest_file=$IW_ALMA_CONFIGURATION_HOME/etc/openldap/slapd.d/$2
    envsubst '$IW_LDAP_SERVICE_ADMIN,$IW_LDAP_SERVICE_GROUP_UNIT,$IW_LDAP_SERVICE_USERS_UNIT,$IW_LDAP_SERVICE_SUBDOMAIN,$IW_LDAP_SERVICE_DOMAIN,$IW_LDAP_SERVICE_EXTENSION' < $iw_conf_source_file > $iw_conf_dest_file
    sudo mv $iw_conf_dest_file /etc/openldap/slapd.d/
    sudo chown -R ldap:ldap /etc/openldap/slapd.d 
    sudo chmod -R go-rwx /etc/openldap/slapd.d
    sudo restorecon -R -F /etc/openldap/slapd.d/
}

function load_iw_ldap_service_conf() {
    sudo ldapadd -Y EXTERNAL -H ldapi:/// -f /etc/openldap/schema/cosine.ldif
    sudo ldapadd -Y EXTERNAL -H ldapi:/// -f /etc/openldap/schema/inetorgperson.ldif
    sudo ldapadd -Y EXTERNAL -H ldapi:/// -f /etc/openldap/schema/nis.ldif
    sudo ldapmodify -Y EXTERNAL -H ldapi:/// -f /etc/openldap/slapd.d/admin.ldif
    sudo ldapmodify -Y EXTERNAL -H ldapi:/// -f /etc/openldap/slapd.d/domain.ldif;
    sudo ldapadd -x -D cn=$IW_LDAP_SERVICE_ADMIN,dc=$IW_LDAP_SERVICE_SUBDOMAIN,dc=$IW_LDAP_SERVICE_DOMAIN,dc=$IW_LDAP_SERVICE_EXTENSION -W -f /etc/openldap/slapd.d/base.ldif
}

init_iw_ldap_service_db

export readonly IW_LDAP_SERVICE_PASS=$(date | base64)
export readonly IW_LDAP_SERVICE_PASS_HASH=$(slappasswd -s $IW_LDAP_SERVICE_PASS)
echo "$IW_LDAP_SERVICE_PASS" | tee --append /etc/openldap/passwd.info
init_add_iw_ldap_service_conf_db "admin.template.ldif" "admin.ldif"
unset IW_LDAP_SERVICE_PASS
unset IW_LDAP_SERVICE_PASS_HASH

add_iw_ldap_service_conf "base.template.ldif" "base.ldif"
add_iw_ldap_service_conf "certs.template.ldif" "certs.ldif"
add_iw_ldap_service_conf "domain.template.ldif" "domain.ldif"
add_iw_ldap_service_conf "monitor.template.ldif" "monitor.ldif"

load_iw_ldap_service_conf
