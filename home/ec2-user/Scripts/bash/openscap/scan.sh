#!/bin/bash
sudo oscap xccdf eval \
    --fetch-remote-resources \
    --profile xccdf_org.ssgproject.content_profile_pci-dss \
    --results pcidss-scan-results.xml \
    /usr/share/xml/scap/ssg/content/ssg-almalinux9-ds.xml

sudo oscap xccdf eval \
    --fetch-remote-resources \
    --profile xccdf_org.ssgproject.content_profile_stig \
    --results stig-scan-results.xml \
    /usr/share/xml/scap/ssg/content/ssg-centos7-ds.xml

oscap xccdf generate report pcidss-scan-results.xml | /bin/mail -r "root@$(hostname)" -s "$(echo -e "$(hostname) - PCI-DSS report\nContent-Type: text/html")" idegaweb@idega.com
oscap xccdf generate report stig-scan-results.xml | /bin/mail -r "root@$(hostname)" -s "$(echo -e "$(hostname) - STIG report\nContent-Type: text/html")" idegaweb@idega.com