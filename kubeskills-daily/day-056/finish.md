<br>

### Resource exhaustion lessons

**Key observations**

- Pending pods signal the scheduler cannot find suitable nodes.
- Fragmentation leaves unusable gaps for large pods.
- Priority preemption evicts lower-priority workloads first.
- DaemonSets schedule everywhere and can worsen pressure.
- Overcommitment lets limits exceed requests and risks throttling.
- Scheduler back-off reduces churn on impossible workloads.

**Production patterns**

```yaml
# Right-sized application
apiVersion: apps/v1
kind: Deployment
spec:
  template:
    spec:
      containers:
      - name: app
        resources:
          requests:
            cpu: "250m"     # Guaranteed minimum
            memory: "512Mi"
          limits:
            cpu: "1000m"    # Burst capacity
            memory: "1Gi"   # Hard limit
```

```yaml
# Priority classes for critical workloads
apiVersion: scheduling.k8s.io/v1
kind: PriorityClass
metadata:
  name: production-critical
value: 10000
globalDefault: false
preemptionPolicy: PreemptLowerPriority
description: "Production critical services"
---
apiVersion: v1
kind: Pod
spec:
  priorityClassName: production-critical
```

```yaml
# Resource quotas per namespace
apiVersion: v1
kind: ResourceQuota
metadata:
  name: team-quota
  namespace: team-a
spec:
  hard:
    requests.cpu: "20"
    requests.memory: "40Gi"
    limits.cpu: "40"
    limits.memory: "80Gi"
    persistentvolumeclaims: "10"
    pods: "50"
```

```yaml
# Prometheus alerts
- alert: ClusterNearCapacity
  expr: |
    sum(kube_pod_container_resource_requests{resource="cpu"}) / 
    sum(kube_node_status_allocatable{resource="cpu"}) > 0.85
  for: 10m
  annotations:
    summary: "Cluster CPU capacity at 85%"

- alert: PodsPendingTooLong
  expr: |
    sum(kube_pod_status_phase{phase="Pending"}) > 5
  for: 15m
  annotations:
    summary: "More than 5 pods pending for 15+ minutes"
```

**Cleanup**

```bash
kubectl delete namespace capacity-test
kubectl delete priorityclass high-priority low-priority
rm -f /tmp/capacity-report.sh
```{{exec}}

---

Next: Day 57 - Pod Security Standards - Enforcement Failures
