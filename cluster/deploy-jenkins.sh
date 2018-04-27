#!/usr/bin/env bash

helm init

kubectl create serviceaccount --namespace kube-system tiller
kubectl create clusterrolebinding tiller-cluster-rule --clusterrole=cluster-admin --serviceaccount=kube-system:tiller
kubectl patch deploy --namespace kube-system tiller-deploy -p '{"spec":{"template":{"spec":{"serviceAccount":"tiller"}}}}'

helm delete --purge jenkins
helm install --name jenkins stable/jenkins -f /home/ec2-user/terraform-aws/cluster/values.yaml

export SERVICE_IP=$(kubectl get svc --namespace default jenkins-jenkins --template "{{ range (index .status.loadBalancer.ingress 0) }}{{ . }}{{ end }}")
echo http://${SERVICE_IP}:8080/login
printf $(kubectl get secret --namespace default jenkins-jenkins -o jsonpath="{.data.jenkins-admin-password}" | base64 --decode);echo
