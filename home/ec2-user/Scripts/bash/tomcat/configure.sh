#!/bin/bash
sudo setsebool tomcat_can_network_connect_db on
sudo setsebool -P tomcat_can_network_connect_db on