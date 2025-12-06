<br>

### Evictions decoded

**Key observations**

✅ Eviction order: BestEffort → Burstable → Guaranteed; priority further influences survival.  
✅ PDBs don't block kubelet evictions—they only cover voluntary disruptions.  
✅ Node conditions (MemoryPressure/DiskPressure/PIDPressure) drive evictions.  
✅ Soft vs hard evictions differ by grace; events reveal which resource triggered them.  
✅ Deployments/ReplicaSets recreate evicted pods automatically.

**Production patterns**

Set sane requests/limits:

```yaml
resources:
  requests:
    memory: "256Mi"
    cpu: "100m"
  limits:
    memory: "512Mi"
    cpu: "500m"
```

Guaranteed QoS for critical workloads:

```yaml
resources:
  requests:
    memory: "1Gi"
    cpu: "500m"
  limits:
    memory: "1Gi"
    cpu: "500m"
```

Set priority classes:

```yaml
apiVersion: v1
kind: Pod
spec:
  priorityClassName: system-cluster-critical
```

Monitor node pressure:

```bash
kubectl get nodes -o json | jq '.items[] | select(.status.conditions[] | select(.type=="MemoryPressure" and .status=="True")) | .metadata.name'
```

**Cleanup**

```bash
kubectl delete pod besteffort-pod burstable-pod guaranteed-pod memory-eater high-priority-pod low-priority-pod disk-filler 2>/dev/null
kubectl delete deployment protected-app 2>/dev/null
kubectl delete pdb protected-pdb 2>/dev/null
kubectl delete priorityclass high-priority low-priority 2>/dev/null
```{{exec}}

---

Next: Day 27 - API Server Rate Limiting
