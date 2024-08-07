Scaling up the statefulSet means adding more replicas, in order to distribute work across the StatefulSet, so more pods can perform more of that work.

Scale the statefulSet to 5 replicas. Watch as the new pods get created (in order).

Scaling down the statefulSet means reducing the number of replicas. You might do this because the level of traffic to your workloads have decreased, and you don't want there to be idle resources.



<br>
<details><summary>Solution</summary>
<br>

```bash
k scale sts web --replicas=5

k get pod --watch -l app=nginx
```{{exec}}

```bash
k patch sts web -p '{"spec":{"replicas":3}}'
```


</details>