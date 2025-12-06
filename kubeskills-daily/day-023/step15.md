## Step 15: Diagnose CNI failures from events

```bash
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: cni-debug
spec:
  containers:
  - name: app
    image: nginx
EOF
```{{exec}}

```bash
kubectl describe pod cni-debug | grep -A 10 Events
kubectl get pod cni-debug -o jsonpath='{.status.conditions[?(@.type=="Ready")].message}'
```{{exec}}

Common errors include network not ready, failed to set up network, or failed IP allocation.
