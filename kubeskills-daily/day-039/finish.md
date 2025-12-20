<br>

### QoS eviction lessons

**Key observations**

- QoS order: BestEffort evicts first, then Burstable exceeding requests, then Guaranteed last.
- PodPriority can influence eviction order even across QoS tiers.
- Requests reserve resources; limits cap usage and can throttle CPU.
- Quotas and LimitRanges stop overconsumption before scheduling.
- Finalizers can block deletion and keep pods Terminating.
- Swap is expected disabled; eviction reacts to memory pressure signals.

**Production patterns**

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: critical-app
spec:
  priorityClassName: system-cluster-critical
  containers:
  - name: app
    image: critical-app:v1
    resources:
      requests:
        memory: "1Gi"
        cpu: "500m"
      limits:
        memory: "1Gi"
        cpu: "500m"
```

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: web-service
spec:
  containers:
  - name: web
    image: nginx
    resources:
      requests:
        memory: "256Mi"
        cpu: "100m"
      limits:
        memory: "512Mi"
        cpu: "500m"
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
      app: critical
```

**Cleanup**

```bash
kubectl delete pod besteffort-pod burstable-pod guaranteed-pod memory-hog low-priority-pod high-priority-pod cpu-throttled finalizer-pod 2>/dev/null
kubectl delete priorityclass high-priority low-priority 2>/dev/null
kubectl delete namespace resource-test
```{{exec}}

---

Next: Day 40 - TBD
