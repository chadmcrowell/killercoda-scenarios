Preemption is the process of evicting pods with lower priority when the node(s) experiences CPU or memory stress.

We can test preemption by simulating that stress and witness the lower priority pods get evicted.

Using `kubectl`, scale the `low-prio` deployment to `6` replicas.

Watch the high priority pod stay running, which the lower priority pods are evicted from the node.


<br>
<details><summary>Solution</summary>
<br>

```bash
# request additional memory
sed -i 's/200Mi/600Mi/' high-prio.yaml

# restart the pod
kubectl replace -f high-prio.yaml --force
```{{exec}}

```bash
# watch the pods get evicted while the high priority pod stays running
kubectl get po -w 
```{{exec}}

</details>