#!/bin/bash

pushd boot

kind create cluster --config mgmt-cluster-config.yaml --name mgmt

kind get kubeconfig --name mgmt > ~/.kube/kind-mgmt.kubeconfig
cp ~/.kube/kind-mgmt.kubeconfig ~/.kube/config

clusterctl init --infrastructure docker

kubectl apply -f https://github.com/vmware-tanzu/carvel-kapp-controller/releases/latest/download/release.yml

curl -L https://carvel.dev/install.sh | bash

kctrl version

kubectl apply -f capd-kapp-app.yaml

popd

sleep 120

kind get kubeconfig --name kind-0 | sed -r 's/(\b[0-9]{1,3}\.){3}[0-9]{1,3}\b'/"127.0.0.1"/ > kind-0.kubeconfig
kubectl apply -f https://docs.projectcalico.org/v3.20/manifests/calico.yaml --kubeconfig kind-0.kubeconfig

sleep 120

kubectl get pods -A --kubeconfig kind-0.kubeconfig

clusterctl describe cluster kind-0

#
