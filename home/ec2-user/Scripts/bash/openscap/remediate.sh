#!/bin/bash
sudo oscap xccdf eval \
    --fetch-remote-resources \
    --remediate \
    --profile xccdf_org.ssgproject.content_profile_pci-dss \
    --results scan-results.xml \
    /usr/share/xml/scap/ssg/content/ssg-almalinux9-ds.xml

#
# Stig fails with Oracle JDK 8
# 

#
# Can't remediate itself
#
sudo authselect select sssd --force
