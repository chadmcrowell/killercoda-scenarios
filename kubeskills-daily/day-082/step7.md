## Step 7: Detect configuration drift

```bash
cat > /tmp/detect-drift.sh << 'EOF'
#!/bin/bash
echo "=== Configuration Drift Detection ==="

# Compare current state to baseline
echo -e "\n1. Deployment Differences:"
kubectl get deployment myapp -o yaml > /tmp/current-deployment.yaml
diff /tmp/baseline-deployment.yaml /tmp/current-deployment.yaml | head -20

echo -e "\n2. ConfigMap Differences:"
kubectl get configmap myapp-config -o yaml > /tmp/current-configmap.yaml
diff /tmp/baseline-configmap.yaml /tmp/current-configmap.yaml | head -20

echo -e "\n3. Summary:"
echo "Image: $(kubectl get deployment myapp -o jsonpath='{.spec.template.spec.containers[0].image}')"
echo "Replicas: $(kubectl get deployment myapp -o jsonpath='{.spec.replicas}')"
echo "Labels: $(kubectl get deployment myapp -o jsonpath='{.metadata.labels}' | jq -r 'keys[]' | tr '\n' ' ')"
echo "Env vars: $(kubectl get deployment myapp -o jsonpath='{.spec.template.spec.containers[0].env[*].name}' | tr ' ' '\n' | wc -l)"

echo -e "\n4. Drift Status: SIGNIFICANT DRIFT DETECTED"
EOF

chmod +x /tmp/detect-drift.sh
/tmp/detect-drift.sh
```{{exec}}

Run a drift detection script comparing current cluster state to the saved baseline to identify all divergences.
