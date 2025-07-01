Preemption is the process of evicting pods with lower priority when the node(s) experiences CPU or memory stress.

We can test preemption by simulating that stress and witness the lower priority pods get evicted.

Using `kubectl`, scale the `low-prio` deployment to `6` replicas.

Watch the high priority pod stay running, which the lower priority pods are evicted from the node.


<br>
<details><summary>Solution</summary>
<br>

```bash
# scale the deployment to create more low priority pods
kubectl scale deploy low-prio --replicas 6
```{{exec}}

```bash
# watch the pods get evicted while the high priority pod stays running
kubectl get po -w 
```{{exec}}

</details>