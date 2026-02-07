## Step 9: Test private registry compromise

```bash
# Simulated compromised private registry
cat <<EOF > /tmp/compromised-registry.yaml
apiVersion: v1
kind: Pod
metadata:
  name: private-registry-pod
spec:
  containers:
  - name: app
    image: mycompany.registry.com/app:v1.0
    # If registry is compromised:
    # - Attacker can replace images
    # - Same tag, different content
    # - No detection without digest pinning
EOF

cat /tmp/compromised-registry.yaml

echo ""
echo "Private registry risks:"
echo "- Insider threat"
echo "- Compromised credentials"
echo "- No image signing"
echo "- Mutable tags"
```{{exec}}

Even private registries can be compromised - without digest pinning, attackers can replace images silently.
