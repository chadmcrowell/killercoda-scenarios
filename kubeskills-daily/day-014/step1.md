## Step 1: Create a namespace with ResourceQuota

```bash
kubectl create namespace quota-test
```{{exec}}

```bash
cat <<EOF | kubectl apply -n quota-test -f -
apiVersion: v1
kind: ResourceQuota
metadata:
  name: strict-quota
spec:
  hard:
    requests.cpu: "500m"
    requests.memory: "512Mi"
    limits.cpu: "1"
    limits.memory: "1Gi"
    pods: "5"
    persistentvolumeclaims: "2"
    services.loadbalancers: "0"
EOF
```{{exec}}

```bash
kubectl get resourcequota -n quota-test
kubectl describe resourcequota strict-quota -n quota-test
```{{exec}}

Confirm hard limits; pods and requests must stay within these bounds.
