Create a complete Kustomize setup and apply it using `kubectl apply -k`.

1. Build a base with a Deployment and Service for `web`.
2. Create a production overlay that adds labels, suffixes, and patches replicas/image.
3. Apply the overlay with `kubectl apply -k` and verify the resulting resources.

<details><summary>Solution</summary>
<br>

```bash
mkdir -p kustomize-demo/base
mkdir -p kustomize-demo/overlays/prod
```{{exec}}

```bash
cat <<'EOF_BASE_DEP' > kustomize-demo/base/deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: web
spec:
  replicas: 2
  selector:
    matchLabels:
      app: web
  template:
    metadata:
      labels:
        app: web
    spec:
      containers:
      - name: nginx
        image: nginx:1.25
        ports:
        - containerPort: 80
EOF_BASE_DEP
```{{exec}}

```bash
cat <<'EOF_BASE_SVC' > kustomize-demo/base/service.yaml
apiVersion: v1
kind: Service
metadata:
  name: web
spec:
  selector:
    app: web
  ports:
  - port: 80
    targetPort: 80
EOF_BASE_SVC
```{{exec}}

```bash
cat <<'EOF_BASE_K' > kustomize-demo/base/kustomization.yaml
resources:
  - deployment.yaml
  - service.yaml
EOF_BASE_K
```{{exec}}

```bash
cat <<'EOF_OVERLAY_K' > kustomize-demo/overlays/prod/kustomization.yaml
resources:
  - ../../base
nameSuffix: -prod
commonLabels:
  env: prod
patches:
  - target:
      kind: Deployment
      name: web
    patch: |
      - op: replace
        path: /spec/replicas
        value: 3
      - op: replace
        path: /spec/template/spec/containers/0/image
        value: nginx:1.25-alpine
EOF_OVERLAY_K
```{{exec}}

```bash
kubectl apply -k kustomize-demo/overlays/prod
```{{exec}}

```bash
kubectl get deploy,svc -l env=prod
```{{exec}}

</details>
