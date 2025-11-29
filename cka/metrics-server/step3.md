If you are running a lot of pods, and want to quickly determine which pods are consuming the most CPU, run the command `k top po --sort-by=cpu`{{exec}}

The output will look similar to the following:
```bash
NAME              CPU(cores)   MEMORY(bytes)   
php-apache        1m           17Mi            
emptydir-simple   0m           1Mi             
pod-hostpath      0m           2Mi 
```

If you'd like to determine which pods are consuming the most memory, run the command `k top po --sort-by=memory`{{exec}}

The output will look similar to the following:
```bash
NAME              CPU(cores)   MEMORY(bytes)   
php-apache        1m           17Mi            
pod-hostpath      0m           2Mi             
emptydir-simple   0m           1Mi
```
___
## CHALLENGE

Use the `kubectl top` command to show the pod metrics for the pod named `php-apache` and sort the container usage within the pod by memory

<br>
<details><summary>Solution</summary>
<br>

```plain
# show the pod and container metrics for the pod named `php-apache`, sorted by memory
k top po php-apache --containers --sort-by=memory
```{{exec}}

</details>