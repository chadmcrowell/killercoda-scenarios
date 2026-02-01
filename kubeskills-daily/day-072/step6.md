## Step 6: Check admission webhook API version

```bash
# Webhooks need to support current API version
cat <<EOF | kubectl apply -f -
apiVersion: admissionregistration.k8s.io/v1
kind: ValidatingWebhookConfiguration
metadata:
  name: version-test-webhook
webhooks:
- name: test.example.com
  clientConfig:
    url: https://example.com/validate
    caBundle: LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0t
  rules:
  - operations: ["CREATE"]
    apiGroups: ["apps"]
    apiVersions: ["v1"]
    resources: ["deployments"]
  admissionReviewVersions: ["v1", "v1beta1"]
  sideEffects: None
  failurePolicy: Ignore
EOF

kubectl get validatingwebhookconfiguration version-test-webhook
```{{exec}}

Webhooks must support current admissionReviewVersions.
