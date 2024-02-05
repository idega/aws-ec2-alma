#!/bin/bash
sudo cp $IW_ALMA_CONFIGURATION_HOME/etc/nginx/conf.d/gzip.conf /etc/nginx/conf.d/
sudo cp $IW_ALMA_CONFIGURATION_HOME/etc/nginx/conf.d/default.conf /etc/nginx/conf.d/
sudo restorecon -F -R /etc/nginx/conf.d/