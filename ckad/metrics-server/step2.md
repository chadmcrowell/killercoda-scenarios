You can also get the CPU and memory usage from individual pods using the `kubectl top` command

Run the command `kubectl top po emptydir-simple --containers`{{exec}} to show the metrics for a pod and it's containers

The output should look similar to the following:

```bash
POD               NAME         CPU(cores)   MEMORY(bytes)   
emptydir-simple   container1   0m           0Mi             
emptydir-simple   container2   0m           0Mi
```
___
## CHALLENGE

Use the `kubectl top` command to show the metrics for the other pod that's running in the default namespace.

<br>
<details><summary>Solution</summary>
<br>

```plain
# get the name of the pod running in the default namespace
k get po
```{{exec}}

```plain
# show the cpu and memory metrics for the pod named pod-hostpath
k top po pod-hostpath
```{{exec}}

</details>