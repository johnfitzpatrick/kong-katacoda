We have set up a Kubernetes cluster just for you.
On the right you can see the terminal of the `master` node, from which you can interact with the cluster using the `kubectl` tool, which is already configured.

For instance, you can get the details of the cluster executing `kubectl cluster-info`{{execute}}

You can view the nodes in the cluster with the command `kubectl get nodes`{{execute}}

You should see 2 nodes: one master and a worker.

Check that you are admin: `kubectl auth can-i create node`{{execute}}

In order to follow this course, you will need a [Sysdig](http://sysdig.com/) Monitor account, with Administrator access privileges.

This lab requires the following environment variables to be set:

- `SYSDIG_AGENT_ACCESS_KEY`: The agent access token. Needed for deploying the agent.
- `SYSDIG_API_TOKEN`: The API token for Sysdig Monitor. Needed for creating the dashboards.

You can find your Sysdig Agent Access Key in the Agent Installation tab of the Settings page, and your Sysdig Monitor API Token in the User Profile tab.

`export SYSDIG_AGENT_ACCESS_KEY="your_own_access_key"`{{copy}}

`export SYSDIG_API_TOKEN="your_own_api_token"`{{copy}}

After copying the commands, you can paste them in the interactive terminal using the right buttom of your mouse.  Remember to use **your own keys**.
