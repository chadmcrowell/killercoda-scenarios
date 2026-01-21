## Step 15: Diagnose image pull issues

```bash
cat > /tmp/image-diagnosis.sh << 'EOF'
#!/bin/bash
echo "=== Image Pull Diagnosis ==="

echo -e "\n1. Pods in ImagePullBackOff:"
kubectl get pods -A --field-selector status.phase=Pending -o json | \
  jq -r '.items[] | select(.status.containerStatuses[]?.state.waiting?.reason == "ImagePullBackOff") | "\(.metadata.namespace)/\(.metadata.name)"'

echo -e "\n2. Recent Image Pull Errors:"
kubectl get events -A --sort-by='.lastTimestamp' | grep -i "pull\|image" | grep -i "error\|fail" | tail -10

echo -e "\n3. Registry Credentials:"
kubectl get secrets -A --field-selector type=kubernetes.io/dockerconfigjson -o custom-columns=NAMESPACE:.metadata.namespace,NAME:.metadata.name

echo -e "\n4. Pods with ImagePullSecrets:"
kubectl get pods -A -o json | \
  jq -r '.items[] | select(.spec.imagePullSecrets != null) | "\(.metadata.namespace)/\(.metadata.name): \(.spec.imagePullSecrets[].name)"' | head -10

echo -e "\n5. Image Pull Policy Distribution:"
kubectl get pods -A -o json | \
  jq -r '.items[].spec.containers[].imagePullPolicy' | sort | uniq -c

echo -e "\n6. Images Using :latest Tag:"
kubectl get pods -A -o json | \
  jq -r '.items[] | select(.spec.containers[].image | endswith(":latest")) | "\(.metadata.namespace)/\(.metadata.name)"' | head -10

echo -e "\n7. Common Image Pull Issues:"
echo "   - Nonexistent tag: Check image exists in registry"
echo "   - Wrong registry URL: Verify registry domain"
echo "   - Missing credentials: Add imagePullSecret"
echo "   - Rate limited: Use authenticated pulls or mirror"
echo "   - Network issues: Check node connectivity to registry"
echo "   - Large image timeout: Increase timeout or use smaller images"
EOF

chmod +x /tmp/image-diagnosis.sh
/tmp/image-diagnosis.sh
```{{exec}}

Run a script to summarize common image pull problems.
