## Step 2: Create an aggressive HPA

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
  minReplicas: 1
  maxReplicas: 10
  metrics:
  - type: Resource
    resource:
      name: cpu
      target:
        type: Utilization
        averageUtilization: 30  # Very aggressive!
EOF
```{{exec}}

```bash
kubectl get hpa cpu-app-hpa -w
```{{exec}}

Watch the HPA as metrics arrive; it may scale quickly once CPU rises.
