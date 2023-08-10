By default, logs from a container get written to STDOUT. The node agent will collect the logs in `/var/log/containers`, but you can also use `kubectl` to tail the logs.

Let's take a look at the YAML for a pod that will echo the date to STDOUT with the command `cat pod-logging.yaml`{{exec}}

You can see from the YAML that this pod is using the busybox image, and the argument that we're passing is a while loop that echos the date every second. 

To create this pod, run the command `k create -f pod-logging.yaml`{{exec}}
