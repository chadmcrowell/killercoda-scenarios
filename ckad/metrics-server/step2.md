You can also get the CPU and memory usage from individual pods using the `kubectl top` command

Run the command `kubectl top po emptydir-simple --containers`{{exec}} to show the metrics for a pod and it's containers

The output should look similar to the following:

```bash
POD               NAME         CPU(cores)   MEMORY(bytes)   
emptydir-simple   container1   0m           0Mi             
emptydir-simple   container2   0m           0Mi
```