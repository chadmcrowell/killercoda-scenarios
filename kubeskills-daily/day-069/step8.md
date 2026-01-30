## Step 8: Test peer authentication issues

```bash
# Simulate certificate mismatch
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: ConfigMap
metadata:
  name: mtls-config
  namespace: mesh-demo
data:
  config: |
    # Simulated mTLS configuration
    mode: STRICT
    # All traffic must use mTLS
    # Pods without valid certificates blocked
EOF

echo "In strict mTLS mode:"
echo "- Pods must have valid client certificates"
echo "- Server must verify client certificates"
echo "- Certificate expiry causes traffic failures"
echo "- Mismatched CA blocks communication"
```{{exec}}

Highlight common mTLS failure modes.
