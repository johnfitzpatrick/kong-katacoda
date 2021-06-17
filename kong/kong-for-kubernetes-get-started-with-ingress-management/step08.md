Now that the Service is protected from over use by consumers with rate limiting, let’s secure the service by requiring authentication.  

In this section, we will implement key based authentication and in the next section we will implement Enterprise grade OpenID Connect authentication.

## Create Key-Auth Plugin
Let’s start by creating a KongPlugin resource for key authentication.

```
cat <<EOF | kubectl apply -f -
apiVersion: configuration.konghq.com/v1
kind: KongPlugin
metadata:
  name: key-auth
  annotations:
    kubernetes.io/ingress.class: kong
plugin: key-auth
EOF
```{{execute}}

```
kongplugin.configuration.konghq.com/key-auth created
```

## Apply Key-Auth Plugin to Ingress

Next, let’s apply key authentication to the Ingress rule by annotating with the key auth resource created.  After applying the plugin, Kong will require a valid key to provide access to the Service.  

To demonstrate the flexibility of applying policy at the appropriate resource(s), notice how the key auth plugin is applied to the Ingress instead of the Service.   This allows to configure for example different policies for different clients to the same service.

```
cat <<EOF | kubectl apply -f -
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: demo
  annotations:
    konghq.com/plugins: key-auth
    kubernetes.io/ingress.class: kong
spec:
  rules:
  - http:
      paths:
      - path: /echo
        backend:
          serviceName: echo
          servicePort: 80
EOF
```{{execute}}

```
ingress.extensions/demo configured
```

## Verify the Ingress is Protected with Key-Auth

Let’s verify access to the service via the ingress now requires authentication.

```
curl -i http://$PROXY_IP/echo
```{{execute}}

```
HTTP/1.1 401 Unauthorized
Date: Tue, 06 Oct 2020 01:20:08 GMT
Content-Type: application/json; charset=utf-8
Connection: keep-alive
WWW-Authenticate: Key realm="kong"
Content-Length: 45
X-Kong-Response-Latency: 1
Server: kong/2.1.4

{
  "message":"No API key found in request"
}
```

## Create Kong Consumer and API Key

Now that access to the Service requires a key to authenticate, let’s create a Consumer and API key.  

Since Kong integrates with the native Kubernetes, we will create a secret for the API key.

```
kubectl create secret generic jason-apikey --from-literal=kongCredType=key-auth --from-literal=key=123456789
```{{execute}}

```
secret/jason-apikey created
```

Let’s now create a Consumer and configure the credentials to use the secret created.

```
cat <<EOF | kubectl apply -f -
apiVersion: configuration.konghq.com/v1
kind: KongConsumer
metadata:
  name: jason
  annotations:
    kubernetes.io/ingress.class: kong
username: jason
credentials:
- jason-apikey
EOF
```{{execute}}

```
kongconsumer.configuration.konghq.com/jason created
```

## Verify Access

Let’s verify access to the Service and this time, pass the API key with the request.  

  ```
  curl -i -H "apikey: 123456789" http://$PROXY_IP/echo
  ```{{execute}}

  ```
  HTTP/1.1 200 OK
  Content-Type: text/plain; charset=UTF-8
  Transfer-Encoding: chunked
  Connection: keep-alive
  Date: Tue, 06 Oct 2020 01:44:04 GMT
  Server: echoserver
  X-RateLimit-Remaining-Minute: 4
  X-RateLimit-Limit-Minute: 5
  RateLimit-Remaining: 4
  RateLimit-Limit: 5
  RateLimit-Reset: 56
  X-Kong-Upstream-Latency: 3
  X-Kong-Proxy-Latency: 1
  Via: kong/2.1.4
  ...
  Request Body:
          -no body in request-
  ```


## Summary

At this point any Consumer with an API key can access this service via the Ingress which may not be desirable.  

Let’s further secure the Service by implementing an Access Control List (ACL) that will control which consumers can access the Service.  

**Next Section: **
Apply Access Control List
