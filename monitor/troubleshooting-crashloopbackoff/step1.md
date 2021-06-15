We have set up a Kubernetes cluster just for you.
On the right you can see the terminal of the `master` node, from which you can interact with the cluster using the `kubectl` tool, which is already configured.

For instance, you can get the details of the cluster executing  
`kubectl cluster-info`{{execute}}

You can view the nodes in the cluster with the command  
`kubectl get nodes`{{execute}}

You should see 2 nodes: one master and a worker.

Check that you are admin:  
`kubectl auth can-i create node`{{execute}}

In order to follow this course, you will need a [Sysdig](http://sysdig.com/) Monitor account, with Administrator access privileges.

If you do not have have a Sysdig account, you can set one up by clicking
[Not a customer? Try for free](https://sysdig.com/sign-up/) and following the instructions.
Refer to the first lab for further details.

Click on the "Sysdig" tab and log in the Sysdig Secure web UI. You can click the ![pop-out](/sysdig/courses/monitor/troubleshooting-crashloopbackoff/assets/00_pop_out.png) icon to open this in a new tab in your browser.

Alternatively you can point your browser at <https://app.sysdigcloud.com>.

After logging in, go to your profile Settings, and in the `Agent Installation` tab you will find your Access Key (something like `5ca1ab1e-d3ad-beef-dea1-deba7ab1ed0c`).  Keep it handy, as you will need it to authorize the agent against the backend.

![Agent key](/sysdig/courses/monitor/troubleshooting-crashloopbackoff/assets/image00.png)
