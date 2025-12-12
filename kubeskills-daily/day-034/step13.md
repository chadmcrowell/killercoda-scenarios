## Step 13: Test LimitRange for default limits

```bash
cat <<'LR' | kubectl apply -f -
apiVersion: v1
kind: LimitRange
metadata:
  name: tenant-limits
  namespace: team-a
spec:
  limits:
  - max:
      cpu: "1"
      memory: "1Gi"
    min:
      cpu: "50m"
      memory: "64Mi"
    default:
      cpu: "200m"
      memory: "256Mi"
    defaultRequest:
      cpu: "100m"
      memory: "128Mi"
    type: Container
LR
```

```bash
cat <<'POD' | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: auto-limits
  namespace: team-a
spec:
  containers:
  - name: app
    image: nginx
POD
```

```bash
kubectl get pod auto-limits -n team-a -o jsonpath='{.spec.containers[0].resources}'
```{{exec}}

Defaults should be applied to the pod.
