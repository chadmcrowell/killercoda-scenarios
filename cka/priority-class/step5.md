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
# watch the low priority pod get evicted while the high priority gets scheduled again
kubectl get po -w 
```{{exec}}

> WARNING: This process will take a while. Please be patient.

After a few minutes, you should see something similar to the following:
```
controlplane:~$ kubectl get po  -w
NAME                        READY   STATUS        RESTARTS   AGE
high-prio                   0/1     Pending       0          58s
low-prio-55c4ff8b4f-9782x   1/1     Running       0          3m34s
low-prio-55c4ff8b4f-99n85   1/1     Running       0          3m34s
low-prio-55c4ff8b4f-g55jh   1/1     Terminating   0          3m34s
low-prio-55c4ff8b4f-7qbr2   0/1     Pending       0          0s
low-prio-55c4ff8b4f-7qbr2   0/1     Pending       0          1s
low-prio-55c4ff8b4f-g55jh   1/1     Terminating   0          3m54s
low-prio-55c4ff8b4f-g55jh   0/1     Error         0          3m55s
high-prio                   0/1     Pending       0          79s
high-prio                   0/1     ContainerCreating   0          80s
low-prio-55c4ff8b4f-g55jh   0/1     Error               0          3m56s
low-prio-55c4ff8b4f-g55jh   0/1     Error               0          3m56s
high-prio                   0/1     ContainerCreating   0          81s
high-prio                   1/1     Running             0          83s
```

</details>