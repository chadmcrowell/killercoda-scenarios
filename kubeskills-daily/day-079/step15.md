## Step 15: Supply chain attack detection

```bash
cat > /tmp/detect-supply-chain.sh << 'EOF'
#!/bin/bash
echo "=== Supply Chain Attack Detection ==="

echo -e "\n1. Images Using 'latest' Tag:"
kubectl get pods -A -o json | \
  jq -r '.items[] | select(.spec.containers[].image | endswith(":latest")) | "\(.metadata.namespace)/\(.metadata.name)"' | head -10

echo -e "\n2. Images from Unknown Registries:"
kubectl get pods -A -o json | \
  jq -r '.items[] | .spec.containers[].image' | \
  grep -v "gcr.io\|k8s.gcr.io\|docker.io" | sort -u | head -10

echo -e "\n3. Images Without Digest:"
kubectl get pods -A -o json | \
  jq -r '.items[] | select(.spec.containers[].image | contains("@sha256:") | not) | "\(.metadata.namespace)/\(.metadata.name): \(.spec.containers[0].image)"' | head -10

echo -e "\n4. High CPU Usage (Crypto Mining?):"
kubectl top pods -A --sort-by=cpu 2>/dev/null | head -10 || echo "Metrics not available"

echo -e "\n5. Recent Image Pulls:"
kubectl get events -A --sort-by='.lastTimestamp' | grep -i "pull" | tail -10

echo -e "\n6. Recommendations:"
echo "   - Pin images to digests"
echo "   - Use approved registries only"
echo "   - Scan all images before deployment"
echo "   - Sign and verify images"
echo "   - Monitor for unusual resource usage"
EOF

chmod +x /tmp/detect-supply-chain.sh
/tmp/detect-supply-chain.sh
```{{exec}}

Run a supply chain detection scan to identify images using latest tags, unknown registries, missing digests, and suspicious resource usage.
