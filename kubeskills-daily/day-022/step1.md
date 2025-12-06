## Step 1: Deploy private image without credentials

```bash
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: private-image-fail
spec:
  containers:
  - name: app
    image: private-registry.example.com/myapp:v1.0
EOF
```{{exec}}

```bash
kubectl get pod private-image-fail -w
```{{exec}}

Watch it fail with ImagePullBackOff or ErrImagePull.
