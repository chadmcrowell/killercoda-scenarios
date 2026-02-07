## Step 2: Test unverified image pull

```bash
# Pull from Docker Hub without verification
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: unverified-image
spec:
  containers:
  - name: app
    image: randomuser/suspicious-app:latest
    # No signature verification!
    # No vulnerability scanning!
    # Trust unknown publisher!
EOF

echo "Risks of unverified images:"
echo "- Unknown maintainer"
echo "- No security guarantees"
echo "- Could contain malware"
echo "- Could have backdoors"
```{{exec}}

Pulling unverified images from public registries means trusting unknown publishers with no security guarantees.
