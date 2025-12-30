## Step 7: Test webhook certificate expiration

```bash
cat <<'EOF' | kubectl apply -f -
apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: webhook-cert
spec:
  secretName: webhook-tls
  duration: 2h
  renewBefore: 1h
  issuerRef:
    name: test-issuer
    kind: Issuer
  dnsNames:
  - webhook.default.svc
  - webhook.default.svc.cluster.local
EOF

cat <<'EOF' | kubectl apply -f -
apiVersion: admissionregistration.k8s.io/v1
kind: ValidatingWebhookConfiguration
metadata:
  name: test-webhook
  annotations:
    cert-manager.io/inject-ca-from: default/webhook-cert
webhooks:
- name: test.webhook.com
  clientConfig:
    service:
      name: webhook
      namespace: default
      path: /validate
    caBundle: ""
  rules:
  - operations: ["CREATE"]
    apiGroups: [""]
    apiVersions: ["v1"]
    resources: ["pods"]
  admissionReviewVersions: ["v1"]
  sideEffects: None
  failurePolicy: Ignore
EOF
```{{exec}}

Webhook uses cert-manager-injected CA and a short-lived cert.
