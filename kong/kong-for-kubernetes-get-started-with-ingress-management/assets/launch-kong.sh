#!/bin/bash
kubectl create namespace kong
kubectl create secret generic kong-enterprise-license --from-file=license=./license.json -n kong
# kubectl apply -f demokong-enterprise-0.10.yaml
kubectl apply -f https://bit.ly/k4k8s
