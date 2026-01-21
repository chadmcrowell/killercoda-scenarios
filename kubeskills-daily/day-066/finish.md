<br>

### Resource quota lessons

**Key observations**

- Quotas are per namespace.
- Requests count toward quota usage.
- Pods must specify requests when quota exists.
- LimitRange provides default requests/limits.
- Multiple quotas can coexist with different scopes.
- Hard limits block creation when exceeded.

**Production patterns**

```yaml
apiVersion: v1
kind: ResourceQuota
metadata:
  name: team-quota
  namespace: team-a
spec:
  hard:
    # Compute resources
    requests.cpu: "20"
    requests.memory: "40Gi"
    limits.cpu: "40"
    limits.memory: "80Gi"
    
    # Storage
    requests.storage: "500Gi"
    persistentvolumeclaims: "20"
    
    # Object counts
    pods: "50"
    services: "20"
    services.loadbalancers: "2"
    services.nodeports: "5"
    
    # Config objects
    configmaps: "30"
    secrets: "30"
    
    # Extended resources
    requests.nvidia.com/gpu: "4"
---
apiVersion: v1
kind: LimitRange
metadata:
  name: team-limits
  namespace: team-a
spec:
  limits:
  - max:  # Maximum per container
      cpu: "4"
      memory: "8Gi"
    min:  # Minimum per container
      cpu: "50m"
      memory: "64Mi"
    default:  # Default limits
      cpu: "500m"
      memory: "512Mi"
    defaultRequest:  # Default requests
      cpu: "100m"
      memory: "128Mi"
    type: Container
  - max:  # Maximum per pod
      cpu: "8"
      memory: "16Gi"
    type: Pod
```

```yaml
# Prometheus alerts
- alert: NamespaceQuotaNearLimit
  expr: |
    (kube_resourcequota{type="used"} / 
     kube_resourcequota{type="hard"}) > 0.9
  for: 10m
  annotations:
    summary: "Namespace {{ $labels.namespace }} quota {{ $labels.resource }} at 90%"

- alert: NamespaceQuotaExceeded
  expr: |
    kube_resourcequota{type="used"} >= 
    kube_resourcequota{type="hard"}
  annotations:
    summary: "Namespace {{ $labels.namespace }} quota {{ $labels.resource }} exceeded"
```

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: myapp
  namespace: team-a
spec:
  replicas: 3
  template:
    spec:
      containers:
      - name: app
        image: myapp:v1.0
        resources:
          requests:
            cpu: "250m"     # Counts toward quota
            memory: "512Mi"
          limits:
            cpu: "1000m"    # Can burst up to this
            memory: "1Gi"
```

**Cleanup**

```bash
kubectl delete namespace quota-test quota-test-2
kubectl delete priorityclass high-priority
rm -f /tmp/quota-diagnosis.sh
```{{exec}}

---

Next: Day 67 - Init Container Failures and Sidecar Issues
