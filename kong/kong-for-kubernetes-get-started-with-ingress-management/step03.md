Now that the Kong Ingress Controller is deployed inside of the cluster, let’s configure an environment variable with the IP address where Kong is accessible. This will be used to send requests into the Kubernetes cluster which will be proxied by Kong.

## Export Kong Proxy IP and set nodePort value and verify Port number.
After Kong is deployed, export the proxy IP:

```
export PROXY_IP=$(kubectl get -o jsonpath="{.spec.clusterIP}" service -n kong kong-proxy)
```{{execute}}

```
kubectl patch service kong-proxy --namespace=kong --type='json' --patch='[{"op": "replace", "path": "/spec/ports/0/nodePort", "value":31112}]'
```{{execute}}

```
service/kong-proxy patched
```

```
kubectl get services -n kong kong-proxy
```{{execute}}

## Optional Reading: Accessing the ingress proxy

kong-proxy is a Kubernetes Service. Kubernetes Services can be accessed in several ways (depending on cluster capabilities and the Service’s type), using:<br/>

    - a ClusterIP address which is available inside the cluster (to pods and nodes) and not outside,

    - a LoadBalancer address (which is typically available to anyone connecting to the cluster, and is the preferred way to expose the Kong proxy to the outer world) - this requires a cloud provider to be configured in the cluster (available out of the box for managed Kubernetes platforms such as AWS, Google Cloud, etc.),

    - a NodePort address (all Kubernetes nodes exposing the service on one, and the same everywhere, TCP/UDP port).

Here we have set up Kong’s proxy (which is the gateway for all the requests to applications we’ll expose via Kong) to expose both a ClusterIP and a LoadBalancer address. Since our Kubernetes cluster (created by K3s) is very simple, it does not support LoadBalancer (more precisely: there is no cloud provider running in our cluster that knows how to configure an external load balancer). Managed Kubernetes clusters (AWS EKS, Google Cloud GKE, etc.) typically support LoadBalancer out of the box.

In the command in the section above, we’ve set PROXY_IP to point to kong-proxy’s ClusterIP address. This means that making requests to this address will work from any Kubernetes node in the cluster.


## Verify setup
Verify the setup by sending a request to the cluster ip address (e.g. $PROXY_IP)

```
curl -i http://$PROXY_IP/
```{{execute}}

```
HTTP/1.1 404 Not Found
Date: Wed, 07 Oct 2020 16:20:28 GMT
Content-Type: application/json; charset=utf-8
Connection: keep-alive
Content-Length: 48
X-Kong-Response-Latency: 0
Server: kong/2.0.4.1-enterprise-k8s

{"message":"no Route matched with those values"}
```

### Results

The `HTTP/1.1 404 Not Found`  with `{"message":"no Route matched with those values"}` response is expected and means requests into the Kubernetes cluster are reaching Kong but since we have not configured any Ingress or routing rules, Kong responds with a 404 and no route matched.

## Summary

**Great!**

The Kubernetes cluster is deployed and the Kong Ingress Controller has been installed successfully.  

**Next Section: **
Deploy Sample Echo Service
