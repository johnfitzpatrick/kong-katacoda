# Step 1

1. Is the cluster running

  ```
  kubectl cluster-info
  ```{{execute}}

1. Can I do stuff?

  ```
  kubectl auth can-i create node
  ```{{execute}}

1. Create namespace
  ```
  kubectl create namespace kong
  ```{{execute}}

1. Create a licence - not sure this works

  ```
  kubectl create secret generic kong-enterprise-license --from-file=license=./license.json -n kong
  ```{{execute}}

1. Do the demokong thing

  ```
  kubectl apply -f demokong-enterprise-0.10.yaml
  ```{{execute}}

  1. Create an Nginx pod and verify itCreate an Nginx pod and verify it

  ```
  kubectl create -f https://k8s.io/examples/application/deployment.yaml --namespace kong
  ```{{execute}}

  ```
  kubectl get pods -n kong
  ```{{execute}}
