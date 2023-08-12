If you are running a lot of pods, and want to quickly determine which pods are consuming the most CPU, run the command `k top po --sort-by=cpu`{{exec}}

If you'd like to determine which pods are consuming the most memory, run the command `k top po --sort-by=memory`{{exec}}
___
## CHALLENGE

Use the `kubectl top` command to show the pod metrics for the pod named `emptydir-simple` and sort the container usage within the pod by memory

<br>
<details><summary>Solution</summary>
<br>

```plain
# show the pod and container metrics for the pod named `emptydir-simple`, sorted by memory
k top po emptydir-simple --containers --sort-by=memory
```{{exec}}

</details>