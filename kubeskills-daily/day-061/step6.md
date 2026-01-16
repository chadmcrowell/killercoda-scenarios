## Step 6: Test failed upgrade

```bash
# Create broken upgrade
cat > broken-app/templates/deployment.yaml << 'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ .Release.Name }}-deployment
spec:
  replicas: {{ .Values.replicaCount }}
  selector:
    matchLabels:
      app: {{ .Release.Name }}
  template:
    metadata:
      labels:
        app: {{ .Release.Name }}
    spec:
      containers:
      - name: {{ .Chart.Name }}
        image: "{{ .Values.image.repository }}:{{ .Values.image.tag }}"
        ports:
        - containerPort: {{ .Values.service.port }}
        livenessProbe:
          httpGet:
            path: /nonexistent  # Will fail!
            port: {{ .Values.service.port }}
          initialDelaySeconds: 1
          failureThreshold: 1
EOF

# Upgrade (pods will fail)
helm upgrade test-release broken-app
sleep 10

# Check status
helm status test-release
kubectl get pods -l app=test-release
```{{exec}}

A bad probe can make an upgrade appear successful but crash pods.
