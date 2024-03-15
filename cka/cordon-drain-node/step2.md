Evict all pods that are currently running on `node01`. 

Finally, once you’ve verified that there are no pods running on `node01`, enable scheduling once again.

<br>
<details><summary>Solution</summary>
<br>

```bash
# evict the pods that are running on node01
kubectl drain node01 --ignore-daemonsets

# verify that there are no pods running on node01
kubectl get po -o wide | grep node01

# mark the node scheduleable once again
kubectl uncordon node01


```{{exec}}


</details>