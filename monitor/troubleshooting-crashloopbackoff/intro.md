In this scenario we **try** to deploy a simple web interface in two layers:

- The backend web servers, implemented using [flask](http://flask.pocoo.org/)
- Frontend reverse proxies implemented using nginx

It is important to use the word "try", because the application stack fails to deploy correctly. The nginx proxies are not able to start, and Kubernetes tries to reboot them several times until it desists marking the pod as [CrashloopBackoff](https://sysdig.com/blog/debug-kubernetes-crashloopbackoff/). A CrashloopBackOff means that you have a pod starting, crashing, starting again, and then crashing again. It’s a common situation in Kubernetes, and can be difficult to troubleshoot.

Goals
-----

- Explore a microservices application using Sysdig Monitor:
  - How many nodes and containers I have on my cluster?
  - Where is each container running?
  - How this microservices application works?
  - Which services talk to each other?
  - What's running inside each container and microservice?
- Troubleshoot a deployment problem.
  - Microservices and containers need specific mechanism to troubleshoot this kind of error.
    - Pod dies in a fraction of a second
    - You don't have logs
    - You cannot just SSH and try to restart the process
    - Therefore, traditional troubleshooting is not feasible
  - You will learn how to debug and troubleshoot a container-oriented deployment
- Reason about dependencies, deployment order and how services find each other in Kubernetes

Competencies required
---------------------

The student needs to understand the basic concepts of microservices applications, containers and Kubernetes. You will be able to check the status of deployed resources (pods, deployments, services) and nodes.
