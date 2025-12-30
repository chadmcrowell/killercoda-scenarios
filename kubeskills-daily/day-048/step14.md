## Step 14: Verify webhook compatibility

```bash
cat <<'EOF' | kubectl apply -f -
apiVersion: admissionregistration.k8s.io/v1
kind: ValidatingWebhookConfiguration
metadata:
  name: version-test-webhook
webhooks:
- name: version.test.com
  clientConfig:
    url: https://example.com/validate
  rules:
  - apiGroups: ["apps"]
    apiVersions: ["v1"]
    operations: ["CREATE"]
    resources: ["deployments"]
  admissionReviewVersions: ["v1"]
  sideEffects: None
EOF
```{{exec}}

```bash
kubectl get validatingwebhookconfigurations version-test-webhook -o jsonpath='{.webhooks[0].admissionReviewVersions}'; echo ""
```{{exec}}

Webhook explicitly targets versioned resources.
