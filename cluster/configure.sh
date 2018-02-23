#!/usr/bin/env bash

# install stuff
sudo yum -y update
sudo yum -y install jq python-pip git

pip install awscli --upgrade --user

curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl

curl -LO https://github.com/kubernetes/kops/releases/download/$(curl -s https://api.github.com/repos/kubernetes/kops/releases/latest | grep tag_name | cut -d '"' -f 4)/kops-linux-amd64

curl -O https://releases.hashicorp.com/terraform/0.11.2/terraform_0.11.2_linux_amd64.zip
unzip terraform_0.11.2_linux_amd64.zip

curl -LO https://kubernetes-helm.storage.googleapis.com/helm-v2.8.1-linux-amd64.tar.gz
tar -xvf helm-v2.8.1-linux-amd64.tar.gz

chmod +x kubectl
chmod +x kops-linux-amd64
chmod +x terraform
chmod +x linux-amd64/helm

sudo mv kubectl /usr/local/bin/
sudo mv kops-linux-amd64 /usr/local/bin/kops
sudo mv terraform /usr/local/bin/terraform
sudo mv linux-amd64/helm /usr/local/bin/helm

rm -rf linux-amd64/
rm terraform_0.11.2_linux_amd64.zip
rm helm-v2.8.1-linux-amd64.tar.gz