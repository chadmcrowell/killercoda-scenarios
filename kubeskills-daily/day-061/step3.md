## Step 3: Test template with syntax error

```bash
# Break the deployment template
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
        - containerPort: {{ .Values.service.port
        # Missing closing bracket!
EOF

# Try to install (will fail)
helm install test-release broken-app 2>&1 || echo "Template syntax error!"
```{{exec}}

Template parsing fails fast on syntax errors.
