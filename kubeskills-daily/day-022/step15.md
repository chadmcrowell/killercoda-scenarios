## Step 15: Pull by digest instead of tag

```bash
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: digest-image
spec:
  containers:
  - name: app
    image: nginx@sha256:4c0fdaa8b6341bfdeca5f18f7837462c80cff90527ee35ef185571e1c327beac
EOF
```{{exec}}

Digests are immutable, removing tag drift or pull confusion.
