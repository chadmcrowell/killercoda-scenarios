## Step 12: Test priority class quota

```bash
# Create priority class
cat <<EOF | kubectl apply -f -
apiVersion: scheduling.k8s.io/v1
kind: PriorityClass
metadata:
  name: high-priority
value: 1000
globalDefault: false
---
apiVersion: v1
kind: ResourceQuota
metadata:
  name: priority-quota
  namespace: quota-test
spec:
  hard:
    pods: "1"
  scopeSelector:
    matchExpressions:
    - scopeName: PriorityClass
      operator: In
      values: ["high-priority"]
EOF

# Create high-priority pod
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: high-pri-pod
  namespace: quota-test
spec:
  priorityClassName: high-priority
  containers:
  - name: app
    image: nginx
    resources:
      requests:
        cpu: "100m"
        memory: "128Mi"
EOF

kubectl describe resourcequota priority-quota -n quota-test
```{{exec}}

Apply quota limits based on priority class.
