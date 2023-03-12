Now that a container is running, take another snapshot of the memory cgroup
```
lscgroup memory:/ > after.memory
```{{exec}}

Compare the two files `before.memory` and `after.memory` with the command
```
diff before.memory after.memory
```{{exec}}

The output should be similar to the following:
```
ubuntu $ diff before.memory after.memory
69a70
> memory:/system.slice/docker-5964361709cda46fd952e2f3f6e0b48e28a5b59fa8124c3652d2851c9e14bcbd.scope
```

Look at the memory from inside the container
```
docker exec -it nginx bash
```{{exec}}

Now that you have a shell inside the container, list the cgroups from within the container
```
cat /proc/$$/cgroup
```{{copy}}

exit out of the container shell
```
exit
```{{copy}}

List the cgroups from outside of the container, notice the similarity to the cgroup from within the container
```
ls /sys/fs/cgroup/memory/system.slice/docker-5964361709cda46fd952e2f3f6e0b48e28a5b59fa8124c3652d2851c9e14bcbd.scope
```{{exec}}

Cat out the memory limit for the containers memory cgroup
```
cat /sys/fs/cgroup/memory/system.slice/docker-5964361709cda46fd952e2f3f6e0b48e28a5b59fa8124c3652d2851c9e14bcbd.scope/memory.limit_in_bytes
```{{exec}}




