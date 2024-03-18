In the currect directory, you will see a file named `pod-tolerate.yaml`. Open the file and add a toleration for the taint that's applied to the control plane node.

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