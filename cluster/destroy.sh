#!/usr/bin/env bash

export KOPS_STATE_STORE=s3://forgerock-dsp-containerisation
export NAME=dsp.k8s.local

#get round a bug in terraform which does not delete non-empty buckets
#aws s3 rm s3://bucket-name --recursive

kops delete cluster --state=${KOPS_STATE_STORE} --name=${NAME} --yes
terraform destroy -force

