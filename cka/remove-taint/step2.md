Find out why the pod is in a pending state. Fix the pod so that it is in a running state.

> HINT: Use kubectl to list the events of the pod.

<br>
<details><summary>Solution</summary>
<br>

```bash
# describe the pod to see why the pod is in a pending state
kubectl describe po nginx
```{{exec}}

```bash
# describe the controlplane node to view the taint applied
kubectl describe no controlplane | grep Taint
```{{exec}}

```bash
# get the pod to run on the control plane by removing the taint
kubectl taint no controlplane node-role.kubernetes.io/control-plane:NoSchedule-
```{{exec}}

```bash
# check to see if the pod is now running and scheduled to the control plane node
kubectl get po -o wide
```{{exec}}


</details>