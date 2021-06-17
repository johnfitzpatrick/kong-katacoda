Let’s now deploy a sample [echo](https://github.com/kubernetes/kubernetes/blob/master/test/images/echoserver/README.md) service in Kubernetes to show case the capabilities of the Kong Ingress Controller.  

Let’s now deploy a sample echo service in Kubernetes to show case the capabilities of the Kong Ingress Controller.  

## Deploy the echo service

```
kubectl apply -f https://bit.ly/sample-echo-service
```{{execute}}

```
service/echo created
deployment.apps/echo created
```

### Verify
Verify that the  echo deployment is deployed and ready.

```
kubectl get deployment --namespace=default
```{{execute}}

```
NAME       READY   UP-TO-DATE   AVAILABLE   AGE
echo       2/2     2            2           52s
```

Results
The ready column displays two numbers: how many pods of a deployment are ready and how many are desired in the `<Ready>/<Desired>` format. Wait until all the desired pods are ready before proceeding to the next step.

## Summary

**Great!**

You have now deployed a Kubernetes cluster, the Kong Ingress Controller and a sample application.

**Next Section: **
Expose, Secure and Protect Service
