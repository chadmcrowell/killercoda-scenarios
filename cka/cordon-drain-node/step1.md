The node named `node01` on the cluster `kubernetes` is experiencing problems with leaking memory. Take down the node for maintenance by first disable the scheduling of new pods to the node.

<br>
<details><summary>Solution</summary>
<br>

```bash
# mark the node01 unschedulable
kubectl cordon node01

# list the nodes to verify that node01 is unschedulable
kubectl get no


```{{exec}}


</details>