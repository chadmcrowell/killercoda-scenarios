## Step 4: Test HPA without resource requests

```bash
cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: no-requests
spec:
  replicas: 1
  selector:
    matchLabels:
      app: no-requests
  template:
    metadata:
      labels:
        app: no-requests
    spec:
      containers:
      - name: app
        image: nginx
        # No resource requests!
---
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: no-requests-hpa
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: no-requests
  minReplicas: 1
  maxReplicas: 5
  metrics:
  - type: Resource
    resource:
      name: cpu
      target:
        type: Utilization
        averageUtilization: 50
EOF

sleep 10
kubectl describe hpa no-requests-hpa | grep -A 5 "Conditions:"
```{{exec}}

HPA fails without resource requests to compute utilization.
