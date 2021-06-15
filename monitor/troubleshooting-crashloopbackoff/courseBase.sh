#!/bin/bash

launch.sh

curl -fsSL https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash
helm version
helm repo add sysdig https://charts.sysdig.com
helm repo update
kubectl create ns sysdig-agent