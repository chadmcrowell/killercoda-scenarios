## Step 9: Test namespaceSelector to exclude kube-system

```bash
cat <<EOF | kubectl apply -f -
apiVersion: admissionregistration.k8s.io/v1
kind: ValidatingWebhookConfiguration
metadata:
  name: namespace-scoped-webhook
webhooks:
- name: scoped.webhook.com
  clientConfig:
    service:
      name: webhook-service
      namespace: default
      path: /validate
    caBundle: LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSURQekNDQWllZ0F3SUJBZ0lVRk1wcnF1OVAwbEcyYmFjQ3UrOHFlaUNYNFNNd0RRWUpLb1pJaHZjTkFRRUwKQlFBd0x6RXRNQ3NHQTFVRUF3d2tRV1J0YVhOemFXOXVJRU52Ym5SeWIyeHNaWElnVjJWaWFHOXZheUJFWlcxdgpJRU5CTUI0WERUSXlNRFF4TlRFMk5EWXhORm9YRFRNeU1EUXhNakUyTkRZeE5Gb3dMekV0TUNzR0ExVUVBd3drClFXUnRhWE56YVc5dUlFTnZiblJ5YjJ4c1pYSWdWMlZpYUc5dmF5QkVaVzF2SUVOQk1JSUJJakFOQmdrcWhraUcKOXcwQkFRRUZBQU9DQVE4QU1JSUJDZ0tDQVFFQXRaVTBWZ3lxQzBxL0E4UGJlZnBhV2pQVjBiMGJrQ2RpdGErNApuMWE2QT09Cg==
  namespaceSelector:
    matchExpressions:
    - key: kubernetes.io/metadata.name
      operator: NotIn
      values: ["kube-system", "kube-public"]  # Exclude system namespaces
  rules:
  - apiGroups: [""]
    apiVersions: ["v1"]
    operations: ["CREATE"]
    resources: ["pods"]
    scope: "*"
  admissionReviewVersions: ["v1"]
  sideEffects: None
  timeoutSeconds: 5
  failurePolicy: Fail
EOF

# Test in kube-system (should work)
kubectl run test-pod -n kube-system --image=nginx
kubectl get pod test-pod -n kube-system
kubectl delete pod test-pod -n kube-system
```{{exec}}

Use namespaceSelector to protect critical namespaces from webhook outages.
