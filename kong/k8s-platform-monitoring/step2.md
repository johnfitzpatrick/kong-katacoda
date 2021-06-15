This lab uses a tweaked version of the Sysdig agent which supports scraping from Prometheus endpoints that uses authentication with private key and certificate. At the time of writing, the work is not merged in the dev branch yet.

Under the `sysdig-agent` directory you will find the following files:

- create.sh
- delete.sh
- dragent.yaml
- sysdig-account.yaml
- sysdig-daemonset-config.yaml
- sysdig-secret.yaml

The `dragent.yaml` file contains the agent configuration. Any customizations that you might need to pass to the Sysdig agent needs to be done here, but in this lab in particular, there is no need to make any changes.

To deploy the Sysdig agent you need to execute `create.sh`:

`cd sysdig-agent;
./create.sh $SYSDIG_AGENT_ACCESS_KEY cloud:katacoda,cluster:training sysdig-training`{{execute}}

After a few moments, you should see the agent pods (one per each Kubernetes node) in `Running` state inside the `sysdig-agent-kubernetes-internal` namespace:

`kubectl get pods -n sysdig-agent-kubernetes-internal`{{execute}}
