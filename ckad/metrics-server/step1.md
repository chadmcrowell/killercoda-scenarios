> NOTE: Please wait 30 seconds for the Metrics Server to be installed

The Metrics API offers a basic set of metrics to support automatic scaling and similar use cases. This API makes information available about resource usage for node and pod, including metrics for CPU and memory.

You can view these metrics by using the `kubectl top` command.

Run the command `k top no controlplane`{{exec}} to view the CPU and memory usage on the control plane node.

The output should look similar to the following:

```bash
NAME           CPU(cores)   CPU%   MEMORY(bytes)   MEMORY%   
controlplane   781m         78%    1238Mi          65% 
```