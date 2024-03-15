From a two node cluster, cordon `node01`

<br>
<details><summary>Solution</summary>
<br>

```bash
# mark the node01 unschedulable (cordon the node)
kubectl cordon node01

# list the nodes to verify that node01 has been cordoned
kubectl get no


```{{exec}}


</details>