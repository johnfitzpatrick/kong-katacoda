We will install the Sysdig Agent using Helm, a package manager for Kubernetes, which is already installed and initialized in this lab environment.

To learn more about Helm, please visit [WordPress in Kubernetes: The Perfect Setup](https://sysdig.com/blog/wordpress-kubernetes-perfect-setup/) on our blog.

We can view the current status of our cluster using the command  
`kubectl get pod -n kube-system`{{execute}}

Create an environment variable with your Access Key:

`MY_AGENT_KEY=FAKECAKEacceskeyInsertYoursHereFAKECAKE`

Remember you have to use **your own access key**.

We also need to be sure about the **region** in which our Sysdig Platform is hosted. If you don't know which region your account is associated with, just observe the **URL** you use to login to Sysdig Monitor or Sysdig Secure. Then, compare it against the offical docs [multi-region](https://docs.sysdig.com/en/saas-regions-and-ip-ranges.html) section. Agent's collector address must be defined based on your account's region. It defaults to US East.  Here you have the different options, choose one to set it up as an environment variable to define yours:

For **US East** do the following:
`MY_REGION_COLLECTOR=collector.sysdigcloud.com`{{execute}}

, for **US West** do the following:
`MY_REGION_COLLECTOR=ingest-us2.app.sysdig.com`{{execute}}

or for **EMEA** do the following:
`MY_REGION_COLLECTOR=ingest-eu1.app.sysdig.com`{{execute}}

After creating the environment variable with your key, you can deploy the Sysdig Agent in a few seconds, as it only takes a simple command:

`helm install sysdig-agent \
    --namespace sysdig-agent \
    --set sysdig.accessKey=$MY_AGENT_KEY \
	--set sysdig.settings.collector=$MY_REGION_COLLECTOR \
    --set sysdig.settings.tags="role:training\,location:universe" \
    sysdig/sysdig`{{execute}}

This will result in a Sysdig Agent Pod being deployed to each node, and thus the ability to monitor any running containers.

You can see that the sysdig agent has been deployed:
`helm ls --all-namespaces`{{execute}}

Creating the containers may take a little time.   Run the command below, which waits for all pods to be ready.  
`watch kubectl get pods -A`{{execute}}  
When the pods show status `Running`, hit <kbd>Ctrl</kbd>-<kbd>C</kbd> and clear the screen.
