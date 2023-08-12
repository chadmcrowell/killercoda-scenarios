An nfs volume allows an existing NFS (Network File System) share to be mounted into a Pod. 

Unlike emptyDir, which is erased when a Pod is removed, the contents of an nfs volume are preserved and the volume is merely unmounted. 

This means that an NFS volume can be pre-populated with data, and that data can be shared between pods. NFS can be mounted by multiple writers simultaneously.

## Install an NFS server on `node01`

ssh to the worker node with the command `ssh node01`{{exec}}

run the script located in the current directory with the command `./nfs-server-install.sh`{{exec}}

> NOTE: Select the defaults when prompted. This scropt will take about 3 minutes to complete. You will only be prompted once.

When the script is finished, exit from the node01 server with the command `exit`{{exec}}