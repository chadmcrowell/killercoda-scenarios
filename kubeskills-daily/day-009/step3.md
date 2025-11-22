## Step 3: Update the ConfigMap

```bash
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: ConfigMap
metadata:
  name: app-config
data:
  APP_MODE: "debug"           # Changed!
  LOG_LEVEL: "verbose"        # Changed!
  config.json: |
    {
      "feature_flag": true,
      "max_connections": 500
    }
EOF
```{{exec}}

Keep watching logs for ~2 minutes: env vars stay `production`/`info` while the volume file updates after about a minute.
