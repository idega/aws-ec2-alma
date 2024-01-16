#!/bin/bash
./variables/export.sh
./tools/install.sh
./firewall/install.sh
./firewall/configure.sh
./sftp/configure.sh
./admin/create.sh
./service/users/create.sh