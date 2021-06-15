When a capture is opened in Sysdig Monitor a browser window will pop up with Sysdig Inspect. Inspect allows you to do system call analysis through a GUI for more efficient correlation and troubleshooting analysis.

![Sysdig Inspect](/sysdig/courses/monitor/troubleshooting-crashloopbackoff/assets/image10.png)

Remember that you can enlarge the screenshots by clicking on them.

To troubleshoot this event we'll want to look at everything that is occurring the infrastructure column of Sysdig Inspect. Selecting the Docker Events tiles will bring those events into the timeline at the bottom.

Let's try to troubleshoot what's going on here. A good first step is to drill down into `Container Died Events`.

![Container died events](/sysdig/courses/monitor/troubleshooting-crashloopbackoff/assets/image11.png)

OK, so it seems that the Nginx containers are having trouble. Looking at the timestamps they die shortly after being created. Let's drill down in any of the Nginx containers and then select `Processes` on the left hand side.

We know our Nginx container only executes one process "nginx" so from the Processes filter by `proc.name = nginx`.

![Filtered processes](/sysdig/courses/monitor/troubleshooting-crashloopbackoff/assets/image12.png)

Sysdig Inspect filters use the Sysdig open-source syntax and can be used to pinpoint activity.

We can click on the Errors section, but nothing significant appears there, no failed system calls. Let's move into the Files section to inspect file system activity.

![Files](/sysdig/courses/monitor/troubleshooting-crashloopbackoff/assets/image13.png)

There will see a `error.log` file, that probably has some information for us. We can see its I/O activity clicking on the I/O Streams icon.

![I/O streams](/sysdig/courses/monitor/troubleshooting-crashloopbackoff/assets/image14.png)

So from the content written in the error.log file until the container died, appears that Nginx cannot resolve a configured upstream server. We know why the Nginx fails, but can we look at what was the configured DNS server for that pod? Sure, just go back and get the streams for resolv.conf.

![I/O streams for resolv.conf](/sysdig/courses/monitor/troubleshooting-crashloopbackoff/assets/image15.png)

From here we can go even further and look at the DNS requests 53/UDP, and seems that the response was not found. This gives us further troubleshooting clues: we deployed the Nginx ReplicaSets first and the upstream Kubernetes service later. Nginx has a particularity, it caches the proxy names (like "flask") at startup time, not upon client request. In other words, we have deployed the different Kubernetes entities in the wrong dependency order.
