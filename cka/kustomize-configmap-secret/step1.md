Use Kustomize to generate a ConfigMap and Secret and apply them to a pod.

1. Scaffold a Kustomize base containing a pod definition.
2. Use `configMapGenerator` and `secretGenerator` to create config data.
3. Apply the overlay and verify the pod receives both the ConfigMap and Secret.

<details><summary>Solution</summary>
<br>

```bash
mkdir -p kustomize-configmap-secret/base
```{{exec}}

```bash
cat <<'EOF_POD' > kustomize-configmap-secret/base/pod.yaml
apiVersion: v1
kind: Pod
metadata:
  name: app
spec:
  containers:
  - name: app
    image: busybox:1.36
    command: ["sh", "-c", "env && sleep 3600"]
    envFrom:
    - configMapRef:
        name: app-config
    - secretRef:
        name: app-secret
EOF_POD
```{{exec}}

```bash
cat <<'EOF_K' > kustomize-configmap-secret/base/kustomization.yaml
resources:
  - pod.yaml
configMapGenerator:
  - name: app-config
    literals:
      - LOG_LEVEL=debug
      - FEATURE_FLAG=true
secretGenerator:
  - name: app-secret
    literals:
      - API_TOKEN=supersecret
      - API_URL=https://api.internal
EOF_K
```{{exec}}

```bash
kubectl apply -k kustomize-configmap-secret/base
```{{exec}}

```bash
kubectl exec app -- printenv LOG_LEVEL FEATURE_FLAG API_TOKEN API_URL
```{{exec}}

</details>
