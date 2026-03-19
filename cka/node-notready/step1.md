The cluster has a deployment `api` running in the `trouble-node-01` namespace, but something has gone wrong. Start by checking node status:

```bash
kubectl get nodes
```{{exec}}

You should see `node01` in `NotReady` state. Even though resources may appear available, the scheduler won't place pods there. Check what the pods are doing:

```bash
kubectl get pods -n trouble-node-01 -o wide
```{{exec}}

Pods are `Pending`. Now dig into the node to find out why:

```bash
kubectl describe node node01
```{{exec}}

Look at the **Conditions** section — the `Ready` condition will show `False` or `Unknown` with a reason like `KubeletNotReady` or `NodeStatusUnknown`.

Check the scheduling events for more detail:

```bash
kubectl get events -n trouble-node-01 --sort-by='.lastTimestamp'
```{{exec}}

You will see messages like `0/2 nodes are available: 1 node(s) had untolerated taint... 1 node(s) were not ready`.

> **Note:** The metrics server was installed as part of this lab's setup. It may take up to 60 seconds to become available. If `kubectl top nodes` returns an error, wait a moment and try again.

> **Key insight:** `kubectl top nodes` shows the *last known* resource usage — it does not reflect schedulability. A node must be `Ready` for the scheduler to place pods on it. Always check `kubectl get nodes` and `kubectl describe node` to understand the scheduler's view of the cluster.
