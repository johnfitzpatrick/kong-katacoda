In this lab, we need to install custom dashboards which are going to help us to get a nice overview about how different Kubernetes components works.

The lab3 directory contains a script that creates those dashboards in our Sysdig Monitor account.

In order to import the dashboards:

`cd;
./create-dashboards.sh $SYSDIG_API_TOKEN`{{execute}}

The script will create a Kubernetes Job which installs those dashboards.  Be careful because the script doesn't check for duplicated dashboards, and you may end with the dashboards repeated.

You can check the progress with the following query to Kubernetes. Wait until `SUCCESSFUL` has a `1` value.

`kubectl get jobs`{{execute}}

Once you have imported the dashboards, you will see them under the Dashboards section of the Sysdig Monitor web interface.