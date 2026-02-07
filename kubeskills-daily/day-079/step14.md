## Step 14: Test admission controller

```bash
# Simulate admission controller blocking unsigned image
cat > /tmp/admission-webhook-example.yaml << 'EOF'
apiVersion: admissionregistration.k8s.io/v1
kind: ValidatingWebhookConfiguration
metadata:
  name: image-verification
webhooks:
- name: verify-images.example.com
  clientConfig:
    url: https://image-verifier.example.com/verify
  rules:
  - operations: ["CREATE", "UPDATE"]
    apiGroups: [""]
    apiVersions: ["v1"]
    resources: ["pods"]
  admissionReviewVersions: ["v1"]
  sideEffects: None
  failurePolicy: Fail  # Block if webhook fails
EOF

cat /tmp/admission-webhook-example.yaml

echo ""
echo "Admission controller enforcement:"
echo "- Validates image signatures"
echo "- Blocks unapproved registries"
echo "- Requires vulnerability scan results"
echo "- Enforces 'latest' tag prohibition"
```{{exec}}

Admission controllers act as the last line of defense, blocking unapproved or unsigned images before they run.
