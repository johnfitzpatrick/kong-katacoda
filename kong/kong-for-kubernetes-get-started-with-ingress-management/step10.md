# Secure Ingress with Open ID Connect (OIDC)

Introduction
In this section we will secure the echo service with OpenID Connect by integrating with a 3rd party IDP instead of using Key authentication. In particular, we will enforce the client credential authentication flow of the OIDC standard.  Kong support many other flows, including "**password**", "**client_credentials**", "**authorization_code**", "**bearer**", "**introspection**", "**kong_oauth2**", "**refresh_token**", "**session**".

## Create OIDC Plugin
As we’ve done before, let’s first create the KongPlugin resource for the OpenID Connect plugin.  We will use Okta for this example, but please note Kong supports MSFT, Ping, Keycloak, Auth0 among many others.  As long as the IDP supports OpenID Connect, Kong should be able to integrate with it.

  ```
  cat <<EOF | kubectl apply -f -
  apiVersion: configuration.konghq.com/v1
  kind: KongPlugin
  metadata:  
    name: openid-connect
    annotations:
      kubernetes.io/ingress.class: kong
  config:  
      issuer: https://dev-513727.okta.com/oauth2/default
      consumer_optional: true
      auth_methods:
        - client_credentials
      verify_parameters: false
      scopes: []
  plugin: openid-connect
  EOF
  ```{{execute}}

  ```
  kongplugin.configuration.konghq.com/openid-connect
  ```

## Apply OIDC Plugin to Ingress
Let’s apply the OpenID Connect plugin to the Ingress.  Note we have replaced key-auth with openid-connect and therefore our Ingress will be protected by OIDC instead of key authentication.

  ```
  cat <<EOF | kubectl apply -f -
  apiVersion: extensions/v1beta1
  kind: Ingress
  metadata:
    name: demo
    annotations:
      konghq.com/plugins: openid-connect
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
  $ ingress.extensions/demo configured
  ```

## Verify the Ingress is Protected with OpenID Connect
Let’s verify the Ingress is protected.

  ```
  curl -i http://$PROXY_IP/echo
  ```{{execute}}

  ```
  HTTP/1.1 401 Unauthorized
  Date: Tue, 06 Oct 2020 15:12:02 GMT
  Content-Type: application/json; charset=utf-8
  Connection: keep-alive
  WWW-Authenticate: Bearer realm="dev-513727.okta.com"
  Content-Length: 26
  X-Kong-Response-Latency: 490
  Server: kong/2.0.4.1-enterprise-k8s

  {"message":"Unauthorized"}
  ```

As expected, we receive a 401 Unauthorized since no credentials were provided to Kong.

## Verify Access
Let’s access the Service again and this time pass in an authorization header with the correct client_id and secret.

  ```
  curl --request GET \
    --url http://$PROXY_IP/echo \
    --header 'authorization: Basic MG9hM2dqZXJ3elRJNXlqN3AzNTc6QS10eWNzc083TldEOEtRNWh6ZWhwWTVtQ0Z2emxIRE93cVpETHYyZA=='
    ```{{execute}}

    ```
  Hostname: echo-85fb7989cc-9mzfm

  Pod Information:
          node name:      node1
          pod name:       echo-85fb7989cc-9mzfm
          pod namespace:  default
          pod IP: 10.42.0.7

  Server values:
          server_version=nginx: 1.12.2 - lua: 10010

  Request Information:
          client_address=10.42.0.6
          method=GET
          real path=/echo
          query=
          request_version=1.1
          request_scheme=http
          request_uri=http://10.43.64.205:8080/echo

  Request Headers:
          accept=*/*
          authorization=Bearer eyJraWQiOiJPV3BDUXhoV0pKTTVLTTJiMVBVaG1ZVGcwR0kwQTZBeWhmeUJaWFhrQjlJIiwiYWxnIjoiUlMyNTYifQ.eyJ2ZXIiOjEsImp0aSI6IkFULnRGZ1BvM3FPOHhtaWdZZmd0Tk1pMkZ5WWNBQ05DSnVULWJVY3VudG9jRlUiLCJpc3MiOiJodHRwczovL2Rldi01MTM3Mjcub2t0YS5jb20vb2F1dGgyL2RlZmF1bHQiLCJhdWQiOiJhcGk6Ly9kZWZhdWx0IiwiaWF0IjoxNjAxOTk3Mjg3LCJleHAiOjE2MDIwMDA4ODcsImNpZCI6IjBvYTNnamVyd3pUSTV5ajdwMzU3Iiwic2NwIjpbIm5hbWUiXSwic3ViIjoiMG9hM2dqZXJ3elRJNXlqN3AzNTcifQ.cUw2nRb7GUKHcGDym5V6tMoND-3HPeD7swmUVpLzy5zSZvtZMtm9_LEfitVlMcGaTk1qIi9I4F4KIXyKoKr3uYpKk_Hk1oYakIt58Te0416gkSSzAk9RpkfvrJUucSZXVAEU95Jh0RtHf-Ilo74Gv-3VQTpO-as58L3vgdeatomrNOECnD2ypuu4OquSsqKZ9xqY4__fyHLZjZGSfuHGeo-ltHFKV43yPhmBRVzWc50JqsNeWchuAKiEVjZn1tObl-Xd2EP22gGSF69jwT_GCD2CXBvAMUxUlmbldLdPgR3tkm0HgPsqz0wgkBl3lwjohTYZHImnzLlfgKgEHx9vIg
          connection=keep-alive
          host=10.43.64.205
          user-agent=curl/7.29.0
          x-forwarded-for=10.42.0.1
          x-forwarded-host=10.43.64.205
          x-forwarded-port=8000
          x-forwarded-proto=http
          x-real-ip=10.42.0.1

  Request Body:
          -no body in request-
  ```

## Results

With credentials being passed in as part of the request, Kong can validate the credentials against the Identity Provider and if successful is able to obtain a bearer token which can be passed to the service for use.  We have a full Workshop on OpenID Connect that explores additional flows and other capabilities of this plugin if interested.


KONGRATUATIONS!
