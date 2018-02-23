#!/usr/bin/env bash

# create the environment
terraform init
terraform apply -auto-approve

export KOPS_STATE_STORE=s3://phud_terraform
export NAME=phud.k8s.local
export AWS_DEFAULT_PROFILE=default
export AWS_PROFILE=default

kops create cluster --name ${NAME} --zones -west-2a --state ${KOPS_STATE_STORE} --yes

echo "To check cluster - wait a couple of minutes, then: kops validate cluster --state=${KOPS_STATE_STORE}"