Not all containers will log to STDOUT, and thats ok! We can deploy a sidecar container to collect the logs instead! 

Let's take a look at a sidecar container that's deployed in a pod, along with the main application container with the command `cat pod-logging-sidecar.yaml`{{exec}}

As you can see, there are two containers within a single pod. The main container is echoing the date to `/var/log/main-container.log` in a loop every 5 seconds.

The sidecar container is tailing the logs from the main container with the command `tail -f /var/log/main-container.log`

The contents of the log will appear in a volume on the container named `varlog`, in the path `/var/log`

Let's create the pod with the command `k create -f pod-logging-sidecar.yaml`{{exec}}