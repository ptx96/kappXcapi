#!/bin/bash

pushd boot

kind create cluster --config mgmt-cluster-config.yaml --name mgmt
kind get kubeconfig --name mgmt > ~/.kube/kind-mgmt.kubeconfig

cp ~/.kube/kind-mgmt.kubeconfig ~/.kube/config

clusterctl init --infrastructure docker

kubectl apply -f argocd.yaml
kubectl apply -f argo-crb.yaml

sleep 90

kubectl apply -f capi-kind-c0.yaml
kubectl get secret argocd-initial-admin-secret -o=jsonpath='{.data.password}' | base64 -d

popd

# kind get kubeconfig --name kind-0
# change server ip

# kind get kubeconfig --name kind-0 | sed -r 's/(\b[0-9]{1,3}\.){3}[0-9]{1,3}\b'/"127.0.0.1"/ > kind-0.kubeconfig
# kubectl apply -f https://docs.projectcalico.org/v3.20/manifests/calico.yaml --kubeconfig kind-0.kubeconfig
#
