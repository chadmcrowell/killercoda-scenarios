ssh to the worker node with the command `ssh node01`{{exec}}

run the script located in the current directory with the command `./nfs-server-install.sh`{{exec}}

select the defaults when prompted

exit from the node01 server with the command `exit`{{exec}}

look at the pod yaml for the pod that will mount the nfs volume from the nfs server we just setup on node01 with the command `cat pod-nfs-vol.yaml`{{exec}}

Now create the pod with the command `k create -f pod-nfs-vol.yaml`{{exec}}
