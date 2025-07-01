A [PriorityClass](https://kubernetes.io/docs/concepts/scheduling-eviction/pod-priority-preemption/) defines how important a pod is compared to others.

Kubernetes uses it when scheduling and evicting pods, especially when the cluster runs out of resources.

In every Kubernetes cluster, there are two built-in high-priority classes. Use the `kubectl` command-line to view the default `priorityclass`.


<br>
<details><summary>Solution</summary>
<br>

```bash
# view the priority classes in a Kubernetes cluster
kubectl get priorityclass
```{{exec}}

These are reserved for Kubernetes system components like `kube-dns`, `kube-proxy`, etc.

When cluster nodes run out of CPU or memory, pods with higher priority will stay running, and pods with lower priority will get preempted (forefully removed).

</details>