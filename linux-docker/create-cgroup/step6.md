Startup a new container, but this time we'll limit the container's memory with the command
```
docker run -d -m 6MB --name nginx2 nginx
```{{exec}}

Get a shell to the container and view the memory limit
```
docker exec -it nginx2 bash
```{{exec}}

Look at the cgroup
```
cat /proc/$$/cgroup&
```{{exec}}

Look at the memory limit
```
exit
cat /sys/fs/cgroup/memory/system.slice/docker-d1e2iueououldj0080808.scope/memory.limit_in_bytes
```{{exec}}

copy the PID from the container using docker top
```
docker top nginx2
```{{exec}}

change into memory cgroup we created before
```
cd /sys/fs/cgroup/memory/new-cgroup
echo 6291456 > memory.limit_in_bytes
```{{exec}}

view the change to the memory cgroup
```
cat memory.limit_in_bytes
```{{exec}}

apply that memory limit to the running process
```
echo 38437 > cgroup.procs
cat /proc/38437/cgroup | grep memory
```{{exec}}

