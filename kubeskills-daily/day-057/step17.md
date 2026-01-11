## Step 17: Test common workload patterns

```bash
# Pattern 1: Database (needs fsGroup)
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: database-pod
  namespace: restricted-ns
spec:
  securityContext:
    runAsNonRoot: true
    runAsUser: 999
    fsGroup: 999
    seccompProfile:
      type: RuntimeDefault
  containers:
  - name: db
    image: postgres:15
    env:
    - name: POSTGRES_PASSWORD
      value: password
    securityContext:
      allowPrivilegeEscalation: false
      runAsNonRoot: true
      runAsUser: 999
      capabilities:
        drop: ["ALL"]
    volumeMounts:
    - name: data
      mountPath: /var/lib/postgresql/data
  volumes:
  - name: data
    emptyDir: {}
EOF

kubectl get pod database-pod -n restricted-ns
```{{exec}}

Common patterns can be made restricted-compliant with fsGroup and seccomp.
