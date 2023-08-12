Now that the `pod-logging-sidecar` container is running, we can get a shell to the sidecar container with the command `k exec -it pod-logging-sidecar -- sh`{{exec}}

Once your prompt changes, you know that you're in the container shell

Let's take a look at the logs from the main container with the command `ls /var/log`