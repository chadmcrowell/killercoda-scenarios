## Step 6: Configure better stabilization

```bash
cat <<EOF | kubectl apply -f -
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: cpu-app-hpa
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: cpu-app
  minReplicas: 2
  maxReplicas: 10
  behavior:
    scaleDown:
      stabilizationWindowSeconds: 600  # 10 minutes
      policies:
      - type: Percent
        value: 10      # Scale down max 10% at a time
        periodSeconds: 60
    scaleUp:
      stabilizationWindowSeconds: 30
      policies:
      - type: Percent
        value: 100     # Can double capacity
        periodSeconds: 15
      - type: Pods
        value: 4       # Or add 4 pods
        periodSeconds: 15
      selectPolicy: Max  # Use whichever adds more
  metrics:
  - type: Resource
    resource:
      name: cpu
      target:
        type: Utilization
        averageUtilization: 50  # More reasonable
EOF
```{{exec}}

This slows scale-down, caps per-interval changes, and uses a less aggressive CPU target.
