## Step 13: Test reconciliation with conditions

```bash
cat <<'APP' | kubectl apply -f -
apiVersion: apps.example.com/v1
kind: WebApp
metadata:
  name: with-conditions
spec:
  message: "Testing conditions"
APP

kubectl patch webapp with-conditions --subresource=status --type=merge -p '{
  "status": {
    "phase": "Creating",
    "conditions": [
      {
        "type": "ConfigMapReady",
        "status": "False",
        "reason": "Creating",
        "message": "ConfigMap is being created",
        "lastTransitionTime": "'"'"$(date -u +%Y-%m-%dT%H:%M:%SZ)'"'""
      }
    ]
  }
}'

kubectl get webapp with-conditions -o yaml | grep -A 10 status
```{{exec}}

Conditions carry structured status with reasons and transition times.
