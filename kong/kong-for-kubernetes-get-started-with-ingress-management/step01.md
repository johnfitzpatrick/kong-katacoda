# Check Kubernetes Cluster


1. Is the cluster running (might take a few seconds)

```
kubectl cluster-info
```{{execute}}

```
Kubernetes master is running at https://172.17.0.24:6443
KubeDNS is running at https://172.17.0.24:6443/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy

To further debug and diagnose cluster problems, use 'kubectl cluster-info dump'.
```

1. Check permissions

```
kubectl auth can-i create node
```{{execute}}

```
yes
```

# Verify all the pods are running

```
kubectl get pods --all-namespaces
```{{execute}}

Kubernetes cluster launched successfully
