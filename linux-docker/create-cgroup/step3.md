# Take a before snapshot of memory cgroup

In order to measure what the memory cgroup looks like before and after we startup a container, we can take a snapshot of the memory cgroup.

In order to interact with our cgroups, and take a snapshot, we can install the `cgroup-tools` package

Install `cgroup-tools` with the following command:
```
apt install -y cgroup-tools
```{{exec}}

Now that we have the tools installed, take a snapshot of the memory cgroup so we can compare
```
lscgroup memory:/ > before.memory
```{{exec}}

