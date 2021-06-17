# Deploy Kong Ingress Controller

To manage Ingress traffic and access Services deployed in Kubernetes using Kong, let’s deploy the Kong Ingress Controller.  


## Install Kong Ingress Controller

Use the script below to deploy Kong Ingress Controller.

  ```
  . launch-kong.sh
  ```{{execute}}

  ```
  namespace/kong created
  secret/kong-enterprise-license created
  customresourcedefinition.apiextensions.k8s.io/kongclusterplugins.configuration.konghq.com created
  customresourcedefinition.apiextensions.k8s.io/kongconsumers.configuration.konghq.com created
  customresourcedefinition.apiextensions.k8s.io/kongcredentials.configuration.konghq.com created
  customresourcedefinition.apiextensions.k8s.io/kongingresses.configuration.konghq.com created
  customresourcedefinition.apiextensions.k8s.io/kongplugins.configuration.konghq.com created
  customresourcedefinition.apiextensions.k8s.io/tcpingresses.configuration.konghq.com created
  serviceaccount/kong-serviceaccount created
  clusterrole.rbac.authorization.k8s.io/kong-ingress-clusterrole created
  clusterrolebinding.rbac.authorization.k8s.io/kong-ingress-clusterrole-nisa-binding created
  configmap/kong-server-blocks created
  service/kong-proxy created
  service/kong-validation-webhook created
  deployment.apps/ingress-kong created
  ```

## Verify installation
Run the following command to wait for Kubernetes Ingress Controller to deploy fully.


  ```
  kubectl wait \
    --for=condition=available \
    --timeout=120s \
    --namespace=kong \
    deployment/ingress-kong
  ```{{execute}}

## View pods

In about 45 seconds, if you check the pods in the kong namespace, Kong will be running alongside the application you deployed earlier:

  ```
  kubectl get pods -n kong
  ```{{execute}}

  ```
  NAME           READY   STATUS    RESTARTS   AGE
  ingress-kong   2/2     Running   0          3m1s
  ```

Notice two containers have been deployed in the pod.  One container is the Kong Ingress Controller and the other is the Kong gateway.  

Next Section: Set up environment variables
