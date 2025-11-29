## Step 8: Test object selector

```bash
cat <<EOF | kubectl apply -f -
apiVersion: admissionregistration.k8s.io/v1
kind: ValidatingWebhookConfiguration
metadata:
  name: labeled-webhook
webhooks:
- name: labeled.example.com
  clientConfig:
    service:
      name: webhook-svc
      namespace: default
      path: /validate
    caBundle: $CA_BUNDLE
  rules:
  - operations: ["CREATE", "UPDATE"]
    apiGroups: [""]
    apiVersions: ["v1"]
    resources: ["pods"]
  objectSelector:
    matchLabels:
      validate: "true"  # Only pods with this label!
  admissionReviewVersions: ["v1"]
  sideEffects: None
  timeoutSeconds: 5
  failurePolicy: Ignore
EOF
```{{exec}}

Only labeled pods are sent to this webhook; unlabeled ones bypass it.
