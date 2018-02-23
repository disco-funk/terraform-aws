#!/usr/bin/env bash

terraform apply --auto-approve
ssh -i ~/.ssh/phud_keypair.pem ec2-user@$(terraform output ec2dns)