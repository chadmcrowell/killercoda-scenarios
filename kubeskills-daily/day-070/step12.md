## Step 12: Test scaling delay and cooldown

```bash
cat <<EOF | kubectl apply -f -
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: delayed-scaling
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: php-apache
  minReplicas: 1
  maxReplicas: 10
  metrics:
  - type: Resource
    resource:
      name: cpu
      target:
        type: Utilization
        averageUtilization: 50
  behavior:
    scaleUp:
      stabilizationWindowSeconds: 60  # Wait 1 min before scale up
      policies:
      - type: Percent
        value: 100  # Double at once
        periodSeconds: 60
    scaleDown:
      stabilizationWindowSeconds: 300  # Wait 5 min before scale down
EOF

echo "Scaling delays prevent flapping but can be slow to react"
```{{exec}}

Tune stabilization windows to avoid flapping.
