You will see two different versions of our application, running as deployments in our Kubernetes cluster.

List the deployments with the command `k get deploy`{{exec}}

These two apps are exposed via two different services in Kubernetes.

List the services with the command `k get svc`{{exec}}

The output should look similar to the following:

```bash
NAME           CPU(cores)   CPU%   MEMORY(bytes)   MEMORY%   
controlplane   781m         78%    1238Mi          65% 
```
___
## CHALLENGE

Use the `kubectl top` command to view the CPU and memory usage for the other node in the cluster.

<br>
<details><summary>Solution</summary>
<br>

```plain
# get the name of the second node in the cluster
k get no
```{{exec}}

```plain
# show the metrics for the node named node01
k top no node01
```{{exec}}

The output should look similar to the following:
```bash
NAME     CPU(cores)   CPU%   MEMORY(bytes)   MEMORY%   
node01   40m          4%     707Mi           37%
```

</details>