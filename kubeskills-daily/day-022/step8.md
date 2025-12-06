## Step 8: Attach secret to a ServiceAccount

```bash
kubectl create serviceaccount image-puller
```{{exec}}

```bash
kubectl patch serviceaccount image-puller -p '{"imagePullSecrets": [{"name": "correct-pull-secret"}]}'
```{{exec}}

```bash
kubectl get serviceaccount image-puller -o yaml | grep -A 3 imagePullSecrets
```{{exec}}

```bash
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: auto-pull-secret
spec:
  serviceAccountName: image-puller
  containers:
  - name: app
    image: private-registry.example.com/myapp:v1.0
EOF
```{{exec}}

The ServiceAccount automatically injects the pull secret for the pod.
