## Step 7: Create working webhook configuration

```bash
openssl req -x509 -newkey rsa:2048 -keyout /tmp/key.pem -out /tmp/cert.pem -days 365 -nodes -subj "/CN=webhook-svc.default.svc"
```{{exec}}

```bash
CA_BUNDLE=$(cat /tmp/cert.pem | base64 | tr -d '\\n')
```{{exec}}

```bash
cat <<EOF | kubectl apply -f -
apiVersion: admissionregistration.k8s.io/v1
kind: ValidatingWebhookConfiguration
metadata:
  name: working-webhook
webhooks:
- name: working.example.com
  clientConfig:
    service:
      name: webhook-svc
      namespace: default
      path: /validate
    caBundle: $CA_BUNDLE
  rules:
  - operations: ["CREATE"]
    apiGroups: [""]
    apiVersions: ["v1"]
    resources: ["configmaps"]
  admissionReviewVersions: ["v1"]
  sideEffects: None
  timeoutSeconds: 5
  failurePolicy: Ignore
EOF
```{{exec}}

Webhook now points to a reachable service with matching CA.
