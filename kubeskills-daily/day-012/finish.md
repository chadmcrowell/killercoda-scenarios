<br>

### HPA storm controlled

**Key observations**

✅ Scale-up is fast; scale-down is intentionally slow to avoid flapping.  
✅ Stabilization windows and per-interval policies tame thrashing.  
✅ Multiple metrics pick the largest replica recommendation—can surprise you.  
✅ Requests/limits shape utilization percentages and scaling signals.

**Production patterns**

Conservative web app HPA:

```yaml
behavior:
  scaleDown:
    stabilizationWindowSeconds: 300
    policies:
    - type: Percent
      value: 10
      periodSeconds: 60
  scaleUp:
    stabilizationWindowSeconds: 0
    policies:
    - type: Percent
      value: 50
      periodSeconds: 30
```

Batch processing HPA (scale-to-zero with KEDA):

```yaml
apiVersion: keda.sh/v1alpha1
kind: ScaledObject
metadata:
  name: batch-processor
spec:
  scaleTargetRef:
    name: batch-processor
  minReplicaCount: 0
  maxReplicaCount: 100
  triggers:
  - type: rabbitmq
    metadata:
      queueName: jobs
      queueLength: "5"
```

**Cleanup**

```bash
kubectl delete hpa cpu-app-hpa multi-metric-hpa 2>/dev/null
kubectl delete deployment cpu-app traffic-sim 2>/dev/null
kubectl delete service cpu-app 2>/dev/null
```{{exec}}

---

Next: Day 13 - PodDisruptionBudget Blocking Node Drains
