#!/bin/bash
sudo oscap xccdf eval \
    --fetch-remote-resources \
    --profile xccdf_org.ssgproject.content_profile_pci-dss \
    --results scan-results.xml \
    /usr/share/xml/scap/ssg/content/ssg-almalinux9-ds.xml

oscap xccdf generate report scan-results.xml | /bin/mail -r "root@$(hostname)" -s "$(echo -e "$(hostname) - PCI-DSS report\nContent-Type: text/html")" idegaweb@idega.com