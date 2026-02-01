## Step 5: Test impossible target utilization

```bash
cat <<EOF | kubectl apply -f -
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: impossible-target
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
        averageUtilization: 10  # Very low target
EOF

# Even idle pods exceed 10% utilization
sleep 10
kubectl get hpa impossible-target
```{{exec}}

An unrealistically low target keeps scaling up.
