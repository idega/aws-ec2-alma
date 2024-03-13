#!/bin/bash
#
# Copy ssh key
#
aws ec2-instance-connect send-ssh-public-key \
    --region eu-west-1 \
    --availability-zone eu-west-1a \
    --instance-id i-0cfb31caf78d886ed \
    --instance-os-user ec2-user \
    --ssh-public-key file://.ssh/id_rsa.pub

#
# Connect to instance
#
ssh -o "IdentitiesOnly=yes" -i .ssh/id_rsa ec2-user@test.idega.is