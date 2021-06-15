In this lab, we are going to generate load in our Kubernetes cluster. It deploys a demo application and deletes from the cluster in a loop, every 30 seconds.

Your home directory contains scripts that wrap around kubectl to stress the Kubernetes cluster.

In order to shake the Kubernetes internals just execute:

`./loadgen.sh`{{execute}}

You will see a loop of applications starts and deletions.

You will be able to stop the loop pressing Ctrl+C.
