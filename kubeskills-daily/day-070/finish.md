<br>

### Autoscaling lessons

**Key observations**

- Metrics-server is required for CPU/memory metrics.
- Resource requests are needed to calculate utilization.
- Targets are % of requests, not limits.
- Avoid HPA and VPA controlling the same resources.
- Stabilization windows prevent flapping.
- Min/max replicas guard against runaway scaling.

**Production patterns**

**Production-ready HPA:**
```yaml
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: production-app-hpa
  namespace: production
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: production-app
  minReplicas: 3  # Always have redundancy
  maxReplicas: 50  # Prevent cost explosion
  metrics:
  - type: Resource
    resource:
      name: cpu
      target:
        type: Utilization
        averageUtilization: 70  # Conservative target
  - type: Resource
    resource:
      name: memory
      target:
        type: Utilization
        averageUtilization: 80
  behavior:
    scaleUp:
      stabilizationWindowSeconds: 60
      policies:
      - type: Percent
        value: 50  # Grow by 50% at once
        periodSeconds: 60
      - type: Pods
        value: 10  # Or add 10 pods
        periodSeconds: 60
      selectPolicy: Max  # Use whichever scales faster
    scaleDown:
      stabilizationWindowSeconds: 300  # Wait 5 min
      policies:
      - type: Percent
        value: 10  # Shrink by 10% at once
        periodSeconds: 60
      selectPolicy: Min  # Use conservative policy
```

**VPA for memory (HPA for replicas):**
```yaml
apiVersion: autoscaling.k8s.io/v1
kind: VerticalPodAutoscaler
metadata:
  name: app-vpa
spec:
  targetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: myapp
  updatePolicy:
    updateMode: "Auto"
  resourcePolicy:
    containerPolicies:
    - containerName: "*"
      controlledResources: ["memory"]  # Only memory!
      minAllowed:
        memory: "128Mi"
      maxAllowed:
        memory: "4Gi"
```

**Custom metrics with Prometheus:**
```yaml
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: custom-metrics-hpa
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: api-server
  minReplicas: 2
  maxReplicas: 20
  metrics:
  - type: Pods
    pods:
      metric:
        name: http_requests_per_second
      target:
        type: AverageValue
        averageValue: "1000"
  - type: Object
    object:
      metric:
        name: requests_per_second
      describedObject:
        apiVersion: v1
        kind: Service
        name: api-server
      target:
        type: Value
        value: "10000"
```

**Monitoring autoscaling:**
```yaml
# Prometheus alerts
- alert: HPAMaxedOut
  expr: |
    kube_horizontalpodautoscaler_status_current_replicas ==
    kube_horizontalpodautoscaler_spec_max_replicas
  for: 15m
  annotations:
    summary: "HPA {{ $labels.namespace }}/{{ $labels.horizontalpodautoscaler }} at max replicas"

- alert: HPAScalingDisabled
  expr: |
    kube_horizontalpodautoscaler_status_condition{condition="ScalingActive",status="false"} == 1
  for: 10m
  annotations:
    summary: "HPA {{ $labels.namespace }}/{{ $labels.horizontalpodautoscaler }} unable to scale"

- alert: FrequentScaling
  expr: |
    rate(kube_horizontalpodautoscaler_status_desired_replicas[5m]) > 0.1
  annotations:
    summary: "HPA {{ $labels.namespace }}/{{ $labels.horizontalpodautoscaler }} scaling too frequently"
```

**Cleanup**

```bash
kubectl delete hpa --all
kubectl delete vpa --all 2>/dev/null
kubectl delete deployment php-apache no-requests
kubectl delete service php-apache
rm -f /tmp/autoscaling-diagnosis.sh
```{{exec}}

---

Next: Day 71 - Operator Failures and Custom Controller Issues
