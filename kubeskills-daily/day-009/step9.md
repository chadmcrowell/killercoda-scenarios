## Step 9: Automatic hash injection with Kustomize

```bash
mkdir -p /tmp/kustomize-demo && cd /tmp/kustomize-demo

cat <<EOF > kustomization.yaml
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
resources:
- deployment.yaml
configMapGenerator:
- name: app-config
  literals:
  - APP_MODE=staging
  - LOG_LEVEL=debug
EOF

cat <<EOF > deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: kustomize-app
spec:
  replicas: 1
  selector:
    matchLabels:
      app: kustomize-app
  template:
    metadata:
      labels:
        app: kustomize-app
    spec:
      containers:
      - name: app
        image: busybox
        command: ['sh', '-c', 'echo "APP_MODE=$APP_MODE"; sleep 3600']
        envFrom:
        - configMapRef:
            name: app-config
EOF

kubectl apply -k .
```{{exec}}

```bash
kubectl get configmap | grep app-config
```{{exec}}

Kustomize adds a hash suffix to the ConfigMap name and updates the pod template to reference it; changing literals and reapplying triggers a rollout automatically.
