## Step 4: Fix syntax and test missing required value

```bash
# Fix deployment template
cat > broken-app/templates/deployment.yaml << 'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ .Release.Name }}-deployment
spec:
  replicas: {{ required "replicaCount is required!" .Values.replicaCount }}
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
EOF

# Remove replicaCount from values
cat > broken-app/values.yaml << 'EOF'
image:
  repository: nginx
  tag: latest

service:
  port: 80
# replicaCount: missing!
EOF

# Try to install
helm install test-release broken-app 2>&1 || echo "Missing required value!"
```{{exec}}

required enforces mandatory values during rendering.
