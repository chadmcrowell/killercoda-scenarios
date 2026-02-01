## Step 11: Test PriorityClass abuse

```bash
# Create high priority class
cat <<EOF | kubectl apply -f -
apiVersion: scheduling.k8s.io/v1
kind: PriorityClass
metadata:
  name: tenant-critical
value: 1000000
globalDefault: false
description: "Critical tenant workloads"
EOF

# Team-a uses high priority to evict team-b pods
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: high-priority-pod
  namespace: team-a
spec:
  priorityClassName: tenant-critical
  containers:
  - name: app
    image: nginx
    resources:
      requests:
        cpu: "2000m"
        memory: "4Gi"
EOF

echo "High priority pods can evict lower priority pods"
echo "Even from other namespaces!"
```{{exec}}

PriorityClass allows cross-namespace pod preemption.
