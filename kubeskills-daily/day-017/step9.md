## Step 9: MutatingWebhook example (conceptual)

```yaml
apiVersion: admissionregistration.k8s.io/v1
kind: MutatingWebhookConfiguration
metadata:
  name: pod-mutator
webhooks:
- name: mutate.example.com
  clientConfig:
    service:
      name: webhook-svc
      namespace: default
      path: /mutate
    caBundle: <BASE64_CA>
  rules:
  - operations: ["CREATE"]
    apiGroups: [""]
    apiVersions: ["v1"]
    resources: ["pods"]
  admissionReviewVersions: ["v1"]
  sideEffects: None
  reinvocationPolicy: Never  # or IfNeeded
  timeoutSeconds: 5
  failurePolicy: Ignore
```

Mutating webhooks can modify objects before creation—keep timeouts small.
