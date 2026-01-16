## Step 6: Test failurePolicy: Ignore (safer)

```bash
cat <<EOF | kubectl apply -f -
apiVersion: admissionregistration.k8s.io/v1
kind: ValidatingWebhookConfiguration
metadata:
  name: safe-webhook
webhooks:
- name: safe.everything.com
  clientConfig:
    service:
      name: webhook-service
      namespace: default
      path: /validate
    caBundle: LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSURQekNDQWllZ0F3SUJBZ0lVRk1wcnF1OVAwbEcyYmFjQ3UrOHFlaUNYNFNNd0RRWUpLb1pJaHZjTkFRRUwKQlFBd0x6RXRNQ3NHQTFVRUF3d2tRV1J0YVhOemFXOXVJRU52Ym5SeWIyeHNaWElnVjJWaWFHOXZheUJFWlcxdgpJRU5CTUI0WERUSXlNRFF4TlRFMk5EWXhORm9YRFRNeU1EUXhNakUyTkRZeE5Gb3dMekV0TUNzR0ExVUVBd3drClFXUnRhWE56YVc5dUlFTnZiblJ5YjJ4c1pYSWdWMlZpYUc5dmF5QkVaVzF2SUVOQk1JSUJJakFOQmdrcWhraUcKOXcwQkFRRUZBQU9DQVE4QU1JSUJDZ0tDQVFFQXRaVTBWZ3lxQzBxL0E4UGJlZnBhV2pQVjBiMGJrQ2RpdGErNApuMWE2QT09Cg==
  rules:
  - apiGroups: [""]
    apiVersions: ["v1"]
    operations: ["CREATE"]
    resources: ["pods"]
    scope: "*"
  admissionReviewVersions: ["v1"]
  sideEffects: None
  timeoutSeconds: 3
  failurePolicy: Ignore  # Allows on failure!
EOF

# Now create pod (works despite webhook being down!)
kubectl run safe-test --image=nginx

# Check pod created
kubectl get pod safe-test
```{{exec}}

Use failurePolicy Ignore to prevent webhook outages from blocking the API.
