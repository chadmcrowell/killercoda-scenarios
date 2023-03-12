Namespaces are a feature of the Linux kernel that partitions kernel resources such that one set of processes sees one set of resources while another set of processes sees a different set of resources.

The following namespaces exist in Linux:
- cgroup
- pid
- user
- ipc
- mnt
- net
- uts

List the namespaces on your system with the command `lsns`

List the cgroup directory, where the cgroups namespace resides on a Linux system:
```
ls /sys/fs/cgroup
```{{exec}}