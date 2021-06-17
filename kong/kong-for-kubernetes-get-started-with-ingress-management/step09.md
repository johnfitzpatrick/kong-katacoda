# Apply Access Control List

In this section, we will create an Access Control List (ACL) and permission our Service to only allow Consumers that are members of a particular group the ability to access the Service.

## Create ACL Secret
Let’s create a new group as a generic secret in Kubernetes we can use to manage which Consumers can access the Service.  

  ```
  kubectl create secret generic app-admin-acl --from-literal=kongCredType=acl --from-literal=group=app-admin
  ```{{execute}}

  ```
  secret/app-admin-acl created
  ```

## Create ACL Plugin
Let’s now the create an ACL KongPlugin resource.  Notice the configuration will allow Consumers that are members of the app-admin group.

  ```
  cat <<EOF | kubectl apply -f -
  apiVersion: configuration.konghq.com/v1
  kind: KongPlugin
  metadata:
    name: admin-acl
    annotations:
      kubernetes.io/ingress.class: kong
  plugin: acl
  config:
    whitelist: ['app-admin']
  EOF
  ```{{execute}}

  ```
  kongplugin.configuration.konghq.com/acl created
  ```

## Apply ACL Plugin to Ingress
Next, let’s apply the ACL plugin to the Ingress in addition to the key auth plugin.  This will require Consumers to authenticate with a key and require those Consumers to be part of the admin-acl group.

  ```
  cat <<EOF | kubectl apply -f -
  apiVersion: extensions/v1beta1
  kind: Ingress
  metadata:
    name: demo
    annotations:
      konghq.com/plugins: key-auth, admin-acl
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

## Verify ACL Plugin
Let’s verify access to the Service.  

  ```
  curl -i -H 'apikey: 123456789' http://$PROXY_IP/echo
  ```{{execute}}

  ```
  HTTP/1.1 403 Forbidden
  Date: Tue, 06 Oct 2020 02:10:16 GMT
  Content-Type: application/json; charset=utf-8
  Connection: keep-alive
  Content-Length: 49
  X-Kong-Response-Latency: 2
  Server: kong/2.1.4

  {
    "message":"You cannot consume this service"
  }
  ```

Why do you think a *403 Forbidden* was returned?  

## Update Jason’s Credentials
The reason the Consumer was unable to access the Service is because they are not a member of the group.

Let’s update Jason’s Consumer resource with the app-admin-acl secret.  This adds Jason to the group app-admin.

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
  - app-admin-acl
  EOF
  ```{{execute}}

  ```
  kongconsumer.configuration.konghq.com/jason configured
  ```

## Verify Access

  ```
  curl -i -H 'apikey: 123456789' http://$PROXY_IP/echo
  ```{{execute}}

  ```
  HTTP/1.1 200 OK
  Content-Type: text/plain; charset=UTF-8
  Transfer-Encoding: chunked
  Connection: keep-alive
  Date: Tue, 06 Oct 2020 02:17:01 GMT
  Server: echoserver
  X-RateLimit-Remaining-Minute: 4
  X-RateLimit-Limit-Minute: 5
  RateLimit-Remaining: 4
  RateLimit-Limit: 5
  RateLimit-Reset: 59
  X-Kong-Upstream-Latency: 2
  X-Kong-Proxy-Latency: 3
  Via: kong/2.1.4
  ...
  ```

## Summary

After this section we have now exposed the Service, protected it and secured it by requiring Consumers to authenticate and be part of a specific group.

Key authentication and ACL groups do a fine job of securing but most Enterprise prefer to integrate with an existing Identity Provider.  

Next Section: Secure Ingress with Open ID Connect (OIDC)
In the next section we will secure the Service by integrating with a 3rd party IDP using OpenID Connect.  Kong support many other security options.  Make sure to checkout the plugin hub for a full list of plugins.
