Use `commonLabels` in a `kustomization.yaml` file to apply labels to all resources.

1. Scaffold a base Kustomize directory with a Deployment and Service.
2. Add `commonLabels` to the base `kustomization.yaml`.
3. Apply the configuration and confirm that every object carries the shared labels.

<details><summary>Solution</summary>
<br>

```bash
mkdir -p kustomize-common-labels/base
```{{exec}}

```bash
cat <<'EOF_DEP' > kustomize-common-labels/base/deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: api
spec:
  replicas: 2
  selector:
    matchLabels:
      app: api
  template:
    metadata:
      labels:
        app: api
    spec:
      containers:
      - name: api
        image: nginx:1.25
        ports:
        - containerPort: 80
EOF_DEP
```{{exec}}

```bash
cat <<'EOF_SVC' > kustomize-common-labels/base/service.yaml
apiVersion: v1
kind: Service
metadata:
  name: api
spec:
  selector:
    app: api
  ports:
  - port: 80
    targetPort: 80
EOF_SVC
```{{exec}}

```bash
cat <<'EOF_K' > kustomize-common-labels/base/kustomization.yaml
resources:
  - deployment.yaml
  - service.yaml
commonLabels:
  env: dev
  team: platform
EOF_K
```{{exec}}

```bash
kubectl apply -k kustomize-common-labels/base
```{{exec}}

```bash
kubectl get deploy,svc -l team=platform -o custom-columns=KIND:.kind,NAME:.metadata.name,ENV:.metadata.labels.env
```{{exec}}

</details>
