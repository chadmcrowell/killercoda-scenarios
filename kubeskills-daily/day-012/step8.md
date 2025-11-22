## Step 7: Test multiple metrics (conflict scenario)

```bash
cat <<EOF | kubectl apply -f -
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: multi-metric-hpa
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: cpu-app
  minReplicas: 2
  maxReplicas: 10
  metrics:
  - type: Resource
    resource:
      name: cpu
      target:
        type: Utilization
        averageUtilization: 50
  - type: Resource
    resource:
      name: memory
      target:
        type: Utilization
        averageUtilization: 70
EOF
```{{exec}}

With multiple metrics, the highest recommended replica count wins. See which metric drives scaling:

```bash
kubectl describe hpa multi-metric-hpa | grep -A 10 "Metrics:"
```{{exec}}
