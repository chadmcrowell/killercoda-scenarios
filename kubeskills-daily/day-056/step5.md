## Step 5: Test priority-based preemption

```bash
# Create high-priority class
cat <<EOF | kubectl apply -f -
apiVersion: scheduling.k8s.io/v1
kind: PriorityClass
metadata:
  name: high-priority
value: 1000
globalDefault: false
description: "High priority for critical workloads"
---
apiVersion: scheduling.k8s.io/v1
kind: PriorityClass
metadata:
  name: low-priority
value: 100
globalDefault: false
description: "Low priority for batch workloads"
EOF

# Deploy low-priority pods
cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: low-priority-app
  namespace: capacity-test
spec:
  replicas: 10
  selector:
    matchLabels:
      app: low-pri
  template:
    metadata:
      labels:
        app: low-pri
    spec:
      priorityClassName: low-priority
      containers:
      - name: app
        image: nginx
        resources:
          requests:
            cpu: "500m"
            memory: "512Mi"
EOF

kubectl wait --for=condition=Ready pods -l app=low-pri -n capacity-test --timeout=120s

# Deploy high-priority pod (should preempt low-priority)
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: high-priority-pod
  namespace: capacity-test
spec:
  priorityClassName: high-priority
  containers:
  - name: app
    image: nginx
    resources:
      requests:
        cpu: "1000m"
        memory: "1Gi"
EOF

# Watch preemption
kubectl get pods -n capacity-test -w
```

Low-priority pods get evicted to make room.
