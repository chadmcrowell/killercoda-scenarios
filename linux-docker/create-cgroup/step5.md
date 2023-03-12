# Compare before and after memory cgroup

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
74a75
> memory:/system.slice/docker-d1304820482038.scope
```

Look at the memory from inside the container
```
docker exec -it nginx bash
```

Now that you have a shell inside the container to see its own cgroups
```
cat /proc/$$/cgroup
```{{exec}}

note the cgroups from inside and outside of the container

```
ls /sys/fs/cgroup/memory/system.slice/docker-d1e2iueououldj0080808.scope
```{{exec}}

Cat out the memory limit for this container
```
cat /sys/fs/cgroup/memory/system.slice/docker-d1e2iueououldj0080808.scope/memory.limit_in_bytes
```{{exec}}




