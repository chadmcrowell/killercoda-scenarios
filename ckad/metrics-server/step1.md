> NOTE: Please wait around 35 seconds for the Metrics Server to be installed

The Metrics API offers a basic set of metrics to support automatic scaling and similar use cases. This API makes information available about resource usage for node and pod, including metrics for CPU and memory.

You can view these metrics by using the `kubectl top` command.

Run the command `k top no controlplane`{{exec}} to view the CPU and memory usage on the control plane node.

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

</details>