<br>

### Evictions understood

**Key observations**

✅ Default pods tolerate NotReady/Unreachable for 300s before eviction.  
✅ Custom tolerations delay (or prevent) eviction; StatefulSets wait on the node.  
✅ DaemonSets include tolerations and survive NotReady/Unreachable by design.  
✅ Node drains evict most pods except DaemonSets; deletionTimestamp shows pending deletes.  
✅ Removing taints/uncordon enables rescheduling; force delete may be needed for stuck pods.

**Production patterns**

Critical system pods (longer wait):

```yaml
tolerations:
- key: node.kubernetes.io/not-ready
  operator: Exists
  effect: NoExecute
  tolerationSeconds: 600
- key: node.kubernetes.io/unreachable
  operator: Exists
  effect: NoExecute
  tolerationSeconds: 600
```

Fast failover for stateless apps:

```yaml
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

StatefulSet with faster recovery:

```yaml
apiVersion: apps/v1
kind: StatefulSet
spec:
  template:
    spec:
      tolerations:
      - key: node.kubernetes.io/not-ready
        operator: Exists
        effect: NoExecute
        tolerationSeconds: 120
```

**Cleanup**

```bash
kubectl delete deployment default-app 2>/dev/null
kubectl delete statefulset stateful-app 2>/dev/null
kubectl delete daemonset node-monitor 2>/dev/null
kubectl delete service stateful 2>/dev/null
kubectl delete pod patient-pod immortal-pod 2>/dev/null
```{{exec}}

---

Next: Day 21 - Finalizers Preventing Deletion (Week 3 Finale!)
