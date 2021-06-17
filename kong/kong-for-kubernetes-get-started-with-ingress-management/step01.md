# Set up Kubernetes Cluster

Run this command in the terminal to bootstrap a lightweight Kubernetes cluster in your environment.

The `launch-k3s.sh` script takes ~45 seconds to complete.

  ```
  ./launch-k3s.sh
  ```{{execute}}

Response

<details>
<summary><b>Response</b></summary>

```The Kubernetes cluster is ready

Verify all the pods are running with: 'kubectl get pods --all-namespaces' Verify Kubernetes cluster launched successfully
```
</details>

The `launch-k3s.sh` script launched a Kubernetes cluster using the K3s distribution, a lightweight Kubernetes distribution.

  ```
  kubectl get nodes
  ```{{execute}}

<details>
<summary><b>Response</b></summary>

Expected response (ensure that all nodes show Ready in the STATUS column):

NAME    STATUS   ROLES    AGE     VERSION]'[
node1   Ready    master   2m46s   v1.17.0+k3s.1

</details>
