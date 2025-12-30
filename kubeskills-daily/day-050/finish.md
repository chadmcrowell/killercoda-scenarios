<br>

### Node failure and eviction lessons

**Key observations**

- Default NoExecute tolerations (300s) delay eviction for not-ready/unreachable nodes.
- Drains are blocked by PDBs; DaemonSets are skipped and tolerate node issues.
- StatefulSet pods can stick Terminating on bad nodes; force deletion may be needed.
- Custom tolerationSeconds change eviction speed; taints drive evictions.
- Eviction storms happen if many nodes fail; cleanup taints/cordons promptly.
- Node pressure (memory/disk/PID) triggers kubelet evictions per thresholds.

**Production patterns**

```yaml
spec:
  tolerations:
  - key: node.kubernetes.io/not-ready
    operator: Exists
    effect: NoExecute
    tolerationSeconds: 30
  - key: node.kubernetes.io/unreachable
    operator: Exists
    effect: NoExecute
    tolerationSeconds: 30
```

```yaml
apiVersion: policy/v1
kind: PodDisruptionBudget
metadata:
  name: critical-pdb
spec:
  minAvailable: 2
  selector:
    matchLabels:
      tier: critical
```

```bash
kubectl cordon $NODE
kubectl drain $NODE --ignore-daemonsets --delete-emptydir-data --grace-period=300 --timeout=600s
```

**Cleanup**

```bash
for node in $(kubectl get nodes -o name); do
  kubectl taint $node node.kubernetes.io/unreachable:NoExecute- 2>/dev/null
  kubectl taint $node node.kubernetes.io/not-ready:NoExecute- 2>/dev/null
  kubectl uncordon ${node#node/} 2>/dev/null
done
kubectl delete deployment multi-node-app protected-app
kubectl delete statefulset stateful-app
kubectl delete service stateful-svc
kubectl delete daemonset node-monitor
kubectl delete pdb protected-pdb
kubectl delete pod node-test fast-eviction 2>/dev/null
```{{exec}}

---

Next: Day 51 - API Server Overload and Request Throttling
