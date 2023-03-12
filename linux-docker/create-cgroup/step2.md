# Create a new cgroup

We can create a new cgroup by simple making a new directory in `/sys/fs/cgroup/`

To create a new directory, use the command 
```
mkdir /sys/fs/cgroup/memory/new-cgroup
```{{exec}}

By creating a new directory, it has cloned the existing memory cgroup. 

List the contents of the new memory cgroups with the command:
```
ls /sys/fs/cgroup/memory/new-cgroup
```{{exec}}


