## Step 11: Test safe dependency pattern (check without blocking)

```bash
cat <<'EOF' | kubectl apply -f -
apiVersion: v1
kind: ConfigMap
metadata:
  name: startup-script
data:
  startup.sh: |
    #!/bin/sh
    echo "Main app starting..."
    
    # Non-blocking check in background
    (
      echo "Checking for optional dependency..."
      for i in $(seq 1 10); do
        if wget -O- --timeout=2 http://service-a:80 2>/dev/null; then
          echo "Dependency available!"
          break
        fi
        echo "Dependency not ready, will retry..."
        sleep 5
      done
    ) &
    
    # Start main app immediately
    nginx -g "daemon off;"
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: safe-dependency
spec:
  replicas: 1
  selector:
    matchLabels:
      app: safe-dep
  template:
    metadata:
      labels:
        app: safe-dep
    spec:
      containers:
      - name: app
        image: nginx
        command: ["/bin/sh", "/scripts/startup.sh"]
        volumeMounts:
        - name: scripts
          mountPath: /scripts
      volumes:
      - name: scripts
        configMap:
          name: startup-script
          defaultMode: 0755
EOF
```{{exec}}

The app starts immediately while a background check probes Service A without blocking startup.
