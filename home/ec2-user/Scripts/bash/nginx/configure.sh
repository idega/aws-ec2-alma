#!/bin/bash
sudo cp $IW_SCRIPT_CONF_DIR/etc/nginx/conf.d/gzip.conf /etc/nginx/conf.d/
sudo restorecon -F -R /etc/nginx/conf.d/