## Step 1: Create a ConfigMap

```bash
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: ConfigMap
metadata:
  name: app-config
data:
  APP_MODE: "production"
  LOG_LEVEL: "info"
  config.json: |
    {
      "feature_flag": false,
      "max_connections": 100
    }
EOF
```{{exec}}

Creates keys for env vars plus a JSON file we'll mount as a volume.
