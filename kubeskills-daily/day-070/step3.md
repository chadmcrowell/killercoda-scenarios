## Step 3: Create HPA without metrics-server

```bash
cat <<EOF | kubectl apply -f -
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: php-apache-hpa
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
EOF

# Check HPA status
sleep 10
kubectl get hpa php-apache-hpa
kubectl describe hpa php-apache-hpa
```{{exec}}

If metrics-server is missing, HPA reports unable to get metrics.
