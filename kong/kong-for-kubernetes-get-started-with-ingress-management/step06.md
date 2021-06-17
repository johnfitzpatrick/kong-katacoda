Let’s expose the echo service outside the Kubernetes cluster by defining Ingress rules.

## Add ingress resource for echo service
The below manifest adds an Ingress resource which proxies requests sent to Kong with a path of  `/echo` to the `echo` service deployed.

```
echo '
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: demo
  annotations:
    konghq.com/strip-path: "true"
    kubernetes.io/ingress.class: kong
spec:
  rules:
  - http:
      paths:
      - path: /echo
        backend:
          serviceName: echo
          servicePort: 80
' | kubectl apply -f -
```{{execute}}

```
ingress.extensions/demo created
```

## Verify endpoint
Test access to the echo service

```
curl -i $PROXY_IP/echo
```{{execute}}

```
HTTP/1.1 200 OK
Content-Type: text/plain; charset=UTF-8
Transfer-Encoding: chunked
Content-Length: 0
Connection: keep-alive
Server: gunicorn/19.9.0
Access-Control-Allow-Origin: *
Access-Control-Allow-Credentials: true
X-Kong-Upstream-Latency: 1
X-Kong-Proxy-Latency: 1
Via: kong/2.0.4.1-enterprise-k8s
....
Request Body:
        -no body in request-
```

A response of  HTTP/1.1 200 OK means Kong successfully proxied the ingress traffic to the echo service and responded to the client accordingly.  

**Next Section: **
Protect Service with Rate Limiting
