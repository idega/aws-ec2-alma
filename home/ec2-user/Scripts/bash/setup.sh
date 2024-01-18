#!/bin/bash
source variables/export.sh
source service/user/function/set_aws_ec2_instance_service_user.sh

./tools/install.sh
./firewall/install.sh
./firewall/configure.sh
./sftp/configure.sh
./admin/create.sh

for aws_ec2_instance_service_user_name in "${AWS_EC2_INSTANCE_SERVICE_USER_NAMES[@]}"; do 
    set_aws_ec2_instance_service_user $aws_ec2_instance_service_user_name
done