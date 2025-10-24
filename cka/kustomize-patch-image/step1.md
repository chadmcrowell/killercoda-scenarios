Use Kustomize to patch a deployment image to `nginx:1.23`.

1. Create base manifests with a Deployment using the original image tag.
2. Configure an overlay that changes the image tag to `1.23`.
3. Apply the overlay and confirm the deployment runs the new image.

<details><summary>Solution</summary>
<br>

```bash
mkdir -p kustomize-patch-image/base
mkdir -p kustomize-patch-image/overlays/stage
```{{exec}}

```bash
cat <<'EOF_DEP' > kustomize-patch-image/base/deployment.yaml
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
        image: nginx:1.21
        ports:
        - containerPort: 80
EOF_DEP
```{{exec}}

```bash
cat <<'EOF_BASE_K' > kustomize-patch-image/base/kustomization.yaml
resources:
  - deployment.yaml
EOF_BASE_K
```{{exec}}

```bash
cat <<'EOF_OVERLAY_K' > kustomize-patch-image/overlays/stage/kustomization.yaml
resources:
  - ../../base
images:
  - name: nginx
    newTag: "1.23"
EOF_OVERLAY_K
```{{exec}}

```bash
kubectl apply -k kustomize-patch-image/overlays/stage
```{{exec}}

```bash
kubectl get deployment web -o jsonpath='{.spec.template.spec.containers[0].image}'
```{{exec}}

</details>
