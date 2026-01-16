## Step 12: Test webhook with certificate error

```bash
# Create webhook with invalid CA bundle
cat <<EOF | kubectl apply -f -
apiVersion: admissionregistration.k8s.io/v1
kind: ValidatingWebhookConfiguration
metadata:
  name: bad-cert-webhook
webhooks:
- name: badcert.webhook.com
  clientConfig:
    service:
      name: webhook-service
      namespace: default
      path: /validate
    caBundle: aW52YWxpZC1jZXJ0aWZpY2F0ZQ==  # Invalid!
  rules:
  - apiGroups: [""]
    apiVersions: ["v1"]
    operations: ["CREATE"]
    resources: ["configmaps"]
  admissionReviewVersions: ["v1"]
  sideEffects: None
  failurePolicy: Fail
EOF

# Try to create ConfigMap
kubectl create configmap test-cm --from-literal=key=value 2>&1 || echo "Certificate validation failed!"
```{{exec}}

Bad CA bundles cause TLS failures that can block all matching requests.
