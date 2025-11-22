## Step 7: Update ConfigMap again

```bash
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: ConfigMap
metadata:
  name: app-config
data:
  APP_MODE: "maintenance"
  LOG_LEVEL: "error"
  config.json: |
    {
      "feature_flag": false,
      "max_connections": 10
    }
EOF
```{{exec}}

```bash
kubectl exec subpath-test -- cat /app/config.json
```{{exec}}

Even after waiting a couple minutes, the subPath file still shows old values—updates never propagate.
