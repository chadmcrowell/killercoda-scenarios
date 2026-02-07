## Step 15: Security scanning

```bash
# Check for insecure pod configurations
cat > /tmp/check-pod-security.sh << 'EOF'
#!/bin/bash
echo "=== Pod Security Scan ==="

echo -e "\n1. Privileged Containers:"
kubectl get pods -A -o json | \
  jq -r '.items[] | select(.spec.containers[].securityContext.privileged == true) | "\(.metadata.namespace)/\(.metadata.name)"'

echo -e "\n2. Root Users:"
kubectl get pods -A -o json | \
  jq -r '.items[] | select(.spec.containers[].securityContext.runAsUser == 0 or .spec.securityContext.runAsUser == 0) | "\(.metadata.namespace)/\(.metadata.name)"'

echo -e "\n3. Host Namespaces:"
kubectl get pods -A -o json | \
  jq -r '.items[] | select(.spec.hostPID == true or .spec.hostNetwork == true or .spec.hostIPC == true) | "\(.metadata.namespace)/\(.metadata.name)"'

echo -e "\n4. hostPath Volumes:"
kubectl get pods -A -o json | \
  jq -r '.items[] | select(.spec.volumes[]?.hostPath != null) | "\(.metadata.namespace)/\(.metadata.name)"'

echo -e "\n5. Dangerous Capabilities:"
kubectl get pods -A -o json | \
  jq -r '.items[] | select(.spec.containers[].securityContext.capabilities.add[]? == "SYS_ADMIN" or .spec.containers[].securityContext.capabilities.add[]? == "NET_ADMIN") | "\(.metadata.namespace)/\(.metadata.name)"'

echo -e "\n6. No Resource Limits:"
kubectl get pods -A -o json | \
  jq -r '.items[] | select(.spec.containers[].resources.limits == null) | "\(.metadata.namespace)/\(.metadata.name)"' | head -10

echo -e "\n7. Security Score Summary:"
TOTAL=$(kubectl get pods -A --no-headers | wc -l)
PRIVILEGED=$(kubectl get pods -A -o json | jq '[.items[] | select(.spec.containers[].securityContext.privileged == true)] | length')
HOST_NS=$(kubectl get pods -A -o json | jq '[.items[] | select(.spec.hostPID == true or .spec.hostNetwork == true)] | length')
ROOT=$(kubectl get pods -A -o json | jq '[.items[] | select(.spec.containers[].securityContext.runAsUser == 0)] | length')

echo "Total Pods: $TOTAL"
echo "Privileged: $PRIVILEGED"
echo "Host Namespace: $HOST_NS"
echo "Running as Root: $ROOT"

if [ $PRIVILEGED -gt 0 ] || [ $HOST_NS -gt 0 ]; then
  echo "CRITICAL: High-risk configurations detected!"
else
  echo "OK: No critical issues found"
fi
EOF

chmod +x /tmp/check-pod-security.sh
/tmp/check-pod-security.sh
```{{exec}}

Run a security scan across the cluster to identify privileged containers, root users, host namespaces, and other high-risk configurations.
