
In this scenario we will deploy a Sysdig Agent which is configured to scrape Kubernetes metrics from its internal components: API Server, Kubelet, Etcd and Scheduler.

We will study how Kubernetes and its different internal parts behave when an application is deployed and removed.

Goals
-----

- Explore Kubernetes from a point of view of state monitoring:
  - Is there enough capacity to serve the pods running on the nodes?
  - Does each deployment have sufficient resources?
  - How many CPU cores and how much memory has been requested by the containers in a Pod?
  - Is Kubernetes Master node having performance problems?
  - How much time is the Scheduler spending to schedule a Pod?
- Identify and understand how the different Kubernetes internal components fits in the puzzle:
  - API Server: The frontend HTTP API. The control plane.
  - Etcd: The persistence backend of all cluster data.
  - Scheduler: How Kubernetes decides which pod execute on each node.
  - Kubelet: The "node agent" which lives on each node.
- Apply Golden Signals also to Kubernetes internal components.
