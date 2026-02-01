## Step 7: Test min/max replica limits

```bash
cat <<EOF | kubectl apply -f -
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: limited-hpa
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: php-apache
  minReplicas: 5  # Always at least 5
  maxReplicas: 5  # Never more than 5
  metrics:
  - type: Resource
    resource:
      name: cpu
      target:
        type: Utilization
        averageUtilization: 50
EOF

# Can't scale below or above limits
kubectl get deployment php-apache
sleep 30
kubectl get deployment php-apache
```{{exec}}

Min and max equal prevents scaling.
