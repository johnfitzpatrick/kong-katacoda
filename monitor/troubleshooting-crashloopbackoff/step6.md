Alerting provides notifications to different teams and members when an application is not behaving as it should:

- Alert me when my application response time is slower than 200ms.
- Alert someone when a microservice is triggering errors.
- Alert the database team when the database service is down.
- Alert the cluster ops team when the number of running pods is less than the desired number of instances.

or there is any situation that someone needs to look at:

- Alert the application team when CPU quota is below 20% (so they can optimize resources).
- Alert the cluster ops when the disk usage is above 80%.
- Alert the cluster ops when the inodes usage is above 80%.

Alerts are configured through a set of parameters:

- A name, a description and a priority.
- A **metric** that this alert will monitor. You can also define how the data is aggregated such as avg, max, min or sum. To alert on multiple metrics using boolean logic, you can switch to _Advanced Mode_.
- A **scope** that will define where in the environment this alert will apply. Use advanced operators to include, exclude, or pattern-match groups, tags, and entities.
  
  You can also create alerts directly from Explore and Dashboards for automatically populating this scope.
- The **trigger conditions** will define the threshold and time window for assessing the alert condition. Boolean logic can be used to define the threshold against a value. Multiple functions allow time aggregation such as on average, as a rate, in sum, at least once or for the entire time.
  
  Additionally a single alert will fire an alert for your entire scope, while multiple alert will fire if any or every segments breach the threshold at once.
  
  On the right hand side, a preview of the previous metric values compared with the configured threshold will help to configure reasonable values and avoid noisy alerts.

For each alert we can configure multiple notifications to different channels (configured through `Settings` → `Notification`), notification retrigger and message format.

But what makes Sysdig really special is the capability to act every time an alert is fired. **Sysdig can trigger a capture** through the Sysdig agent. Using this capture we will be able to record all the system calls and perform syscall tracing for advanced troubleshooting of the issue.

Here you will be able to configure where the capture file is stored, the file name prefix the time frame and a capture filter.

Capture files can grow quickly but the size will depend on 3 parameters: how busy is the server, the capture time and filter. Typically on containerized infrastructure things happen quite fast so a small period of time like 15 seconds should be enough to capture enough information. By default the capture filter is empty, so the capture will include information from the entire host and all the running containers. If you have a very busy server you might decide to configure a capture filter here, for example `container.name contains nginx`, if you want to capture syscalls from your Nginx containers. Please have a look at the [Sysdig open source documentation](https://github.com/draios/sysdig/wiki/sysdig-user-guide) for more information on filters.

For this lab, we will be using an alert: `[Kubernetes] CrashLoopBackOff`

![Pod CrashLoopBackOff](/sysdig/courses/monitor/troubleshooting-crashloopbackoff/assets/image06.png)

Let's analyze the different components of the alert

- Alert severity, at the top, we have set this to _Medium_, this parameter is useful to order alerts by urgency when you are looking at the stream of events.
- The metric we are using in this alert is the `Sum` count of `kubernetes.pod.restart.count`, using the advanced editor, you can [combine several boolean expressions](https://sysdigdocs.atlassian.net/wiki/spaces/Monitor/pages/205324292/Alerts#Alerts-AdvancedAlertThresholds).
- The scope limits the origin and type of events that will be considered, we want to limit this alert to the `nginx-flask` namespace.
- We will trigger the alert if the error condition is detected at least twice per minute, this threshold is very low for real production scenarios, but will help to quickly trigger the alert for our training purposes. You will need to determine what is the acceptable number of errors per minute based on user experience and previous behavior.
- If this alert is triggered, it will produce a Sysdig capture file called `alert-capture`. This capture file will container a complete trace down to the Linux system call level of detail for every pod and process in your application. We will go back to this capture later on.
