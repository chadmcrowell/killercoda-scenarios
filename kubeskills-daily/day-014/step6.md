## Step 6: Add LimitRange for automatic defaults

```bash
cat <<EOF | kubectl apply -n quota-test -f -
apiVersion: v1
kind: LimitRange
metadata:
  name: default-limits
spec:
  limits:
  - default:
      cpu: 200m
      memory: 256Mi
    defaultRequest:
      cpu: 100m
      memory: 128Mi
    max:
      cpu: 500m
      memory: 512Mi
    min:
      cpu: 50m
      memory: 64Mi
    type: Container
EOF
```{{exec}}

```bash
kubectl delete deployment no-resources -n quota-test
```{{exec}}

```bash
cat <<EOF | kubectl apply -n quota-test -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: auto-limits
spec:
  replicas: 1
  selector:
    matchLabels:
      app: auto-limits
  template:
    metadata:
      labels:
        app: auto-limits
    spec:
      containers:
      - name: app
        image: nginx
        # No resources defined - LimitRange injects defaults
EOF
```{{exec}}

```bash
kubectl get pod -n quota-test -l app=auto-limits -o jsonpath='{.items[0].spec.containers[0].resources}'
echo ""
```{{exec}}

Defaults from the LimitRange are injected, satisfying quota requirements.
