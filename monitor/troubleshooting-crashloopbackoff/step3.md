The server application is a simple python flask script that returns a message as a response to a `GET /` request,  the deployment will start off with 2 servers but you can easily scale it using the supporting [Kubernetes deployments](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#scaling-a-deployment).

Let's install this 2-tier web application stack in our Kubernetes cluster.

Your home directory contains simple scripts to create and destroy the application. The application is auto-contained in its own Kubernetes namespace.

Just execute:

`./create.sh`{{execute}}

This will create:

- The `nginx-flask` namespace
- A `flask` deployment composed of 2 backend servers
- A `monitorcronagent` deployment composed of 1 agent pod
  - This pod is just a supporting element that we can use to `curl` the service or to automate triggering and stopping the error condition
- An `nginx` deployment with 0 replicas
  - The frontend reverse proxies have their own deployment, but we start with 0 replicas because we want to manually control when to trigger the error for this exercise. You can scale this deployment any time you want, but the spawned pods will fail to run (as expected)

Wait until all the pods reach Running state:

`kubectl get pod -n nginx-flask`{{execute}}
