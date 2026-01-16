## Step 10: Test objectSelector

```bash
cat <<EOF | kubectl apply -f -
apiVersion: admissionregistration.k8s.io/v1
kind: ValidatingWebhookConfiguration
metadata:
  name: label-scoped-webhook
webhooks:
- name: label.scoped.com
  clientConfig:
    service:
      name: webhook-service
      namespace: default
      path: /validate
    caBundle: LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSURQekNDQWllZ0F3SUJBZ0lVRk1wcnF1OVAwbEcyYmFjQ3UrOHFlaUNYNFNNd0RRWUpLb1pJaHZjTkFRRUwKQlFBd0x6RXRNQ3NHQTFVRUF3d2tRV1J0YVhOemFXOXVJRU52Ym5SeWIyeHNaWElnVjJWaWFHOXZheUJFWlcxdgpJRU5CTUI0WERUSXlNRFF4TlRFMk5EWXhORm9YRFRNeU1EUXhNakUyTkRZeE5Gb3dMekV0TUNzR0ExVUVBd3drClFXUnRhWE56YVc5dUlFTnZiblJ5YjJ4c1pYSWdWMlZpYUc5dmF5QkVaVzF2SUVOQk1JSUJJakFOQmdrcWhraUcKOXcwQkFRRUZBQU9DQVE4QU1JSUJDZ0tDQVFFQXRaVTBWZ3lxQzBxL0E4UGJlZnBhV2pQVjBiMGJrQ2RpdGErNApuMWE2QT09Cg==
  objectSelector:
    matchLabels:
      validate: "true"  # Only validate labeled objects
  rules:
  - apiGroups: [""]
    apiVersions: ["v1"]
    operations: ["CREATE"]
    resources: ["pods"]
  admissionReviewVersions: ["v1"]
  sideEffects: None
  failurePolicy: Fail
EOF

# Test without label (bypasses webhook)
kubectl run no-label-pod --image=nginx
kubectl get pod no-label-pod
```{{exec}}

objectSelector lets you scope webhook enforcement to labeled resources.
