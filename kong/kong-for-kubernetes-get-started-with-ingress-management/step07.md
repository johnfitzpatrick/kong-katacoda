# Protect Service with Rate Limiting

Thus far we’ve exposed the echo serviced deployed to the outside world with Kong.  However, we have not protected this service from misuse.  Any user, application or bot can access this service as many times as they can which could degrade the performance or make the service unavailable.

To protect the service from misuse or overuse by specific consumers, let’s apply rate-limiting.  Rate limiting controls how many times a client can access the service in a specified time frame.

To accomplish this in Kong is very straight forward with the use of Kong plug-ins and in particular use the Rate limiting plug-in to protect the service.  Kong has a rich eco-system of plugins available.    

To enforce rate limiting, we will leverage the Kong Custom Resource Definitions (CRDs) to define a KongPlugin resource and then annotate the service.  

Notice how this all done using native Kubernetes tooling and concepts which is a major benefit of the Kong Ingress Controller.  

## Create Rate-Limiting Plugin
Let’s create a rate limit that will by client IP address limit the number of requests to 5 per minute.

  ```
  cat <<EOF | kubectl apply -f -
  apiVersion: configuration.konghq.com/v1
  kind: KongPlugin
  metadata:
    name: rl-by-ip
    annotations:
      kubernetes.io/ingress.class: kong
  config:
    minute: 5
    limit_by: ip
    policy: local
  plugin: rate-limiting
  EOF
  ```{{execute}}

  ```
  kongplugin.configuration.konghq.com/rl-by-ip created
  ```

## Verify Rate-Limiting Plugin
Let’s verify the rate limiting plug-in was created by querying the KongPlugin resource.

  ```
  {{execute}}
  kubectl get KongPlugin -n default
  ```{{execute}}

  ```
  NAME       PLUGIN-TYPE     AGE
  rl-by-ip   rate-limiting   1m
  ```


## Apply Rate-Limiting Plugin to Service

Now that the rate limiting plug-in resource has been created, we can apply the plugin to the echo service to enforce rate limiting for the service.  

Note: We can also apply the plugin at the Ingress or globally which provides the flexibility apply policy at the desired resources.  For example, imagine you want to enforce a global rate limit for all services but enforce a different rate limit for specific services or consumers, this can be easily accomplished.

  ```
  cat <<EOF | kubectl apply -f -
  apiVersion: v1
  kind: Service
  metadata:
    annotations:
      konghq.com/plugins: rl-by-ip
      kubernetes.io/ingress.class: kong
    labels:
      app: echo
    name: echo
  spec:
    ports:
    - port: 8080
      name: high
      protocol: TCP
      targetPort: 8080
    - port: 80
      name: low
      protocol: TCP
      targetPort: 8080
    selector:
      app: echo
  EOF
  ```{{execute}}

  ```
  $ service/echo configured
  ```

## Verify Service is Rate-Limited

Let’s verify the rate limit is enforced on the Service by executing a request.

  ```
  curl -i http://$PROXY_IP/echo
  ```{{execute}}

Notice how the response includes additional headers that inform us that rate limiting is applied along with the details of the rate limiting, including how many times the client can access the service and when the limit will reset.   

  ```
  HTTP/1.1 200 OK
  Content-Type: text/plain; charset=UTF-8
  Transfer-Encoding: chunked
  Connection: keep-alive
  Date: Wed, 07 Oct 2020 18:37:42 GMT
  Server: echoserver
  X-RateLimit-Remaining-Minute: 4
  X-RateLimit-Limit-Minute: 5
  RateLimit-Remaining: 4
  RateLimit-Limit: 5
  RateLimit-Reset: 18
  X-Kong-Upstream-Latency: 0
  X-Kong-Proxy-Latency: 2
  Via: kong/2.0.4.1-enterprise-k8s
  ...
  Request Body:
          -no body in request-
  ```

Let’s now access the service 6 times and confirm the rate limit is enforced:

  ```
  curl -i http://$PROXY_IP/echo
  curl -i http://$PROXY_IP/echo
  curl -i http://$PROXY_IP/echo
  curl -i http://$PROXY_IP/echo
  curl -i http://$PROXY_IP/echo
  curl -i http://$PROXY_IP/echo
  ```{{execute}}

  ```
  HTTP/1.1 429 Too Many Requests
  Date: Wed, 07 Oct 2020 18:42:41 GMT
  Content-Type: application/json; charset=utf-8
  Connection: keep-alive
  Retry-After: 19
  Content-Length: 37
  X-RateLimit-Remaining-Minute: 0
  X-RateLimit-Limit-Minute: 5
  RateLimit-Remaining: 0
  RateLimit-Limit: 5
  RateLimit-Reset: 19
  X-Kong-Response-Latency: 0
  Server: kong/2.0.4.1-enterprise-k8s

  {"message":"API rate limit exceeded"}
  ```

Next section: Secure Ingress with Key Authentication
