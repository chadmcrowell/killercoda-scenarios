## Step 5: Exempt critical namespaces

```bash
cat <<EOF | kubectl apply -f -
apiVersion: admissionregistration.k8s.io/v1
kind: ValidatingWebhookConfiguration
metadata:
  name: safe-webhook
webhooks:
- name: safe.example.com
  clientConfig:
    service:
      name: nonexistent-webhook
      namespace: default
      path: /validate
    caBundle: LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSURQekNDQWllZ0F3SUJBZ0lVRmFxK3E4L0N5dDRlSTZpRkpUdE1XTGxKRDhNd0RRWUpLb1pJaHZjTkFRRUwKQlFBd0x6RXRNQ3NHQTFVRUF3d2tRV1J0YVhOemFXOXVJRU52Ym5SeWIyeHNaWElnVjJWaWFHOXZheUJFWlcxdgpJRU5CTUI0WERUSXpNRFl5TmpFM01qQXdNRm9YRFRJek1EY3lOakUzTWpBd01Gb3dMekV0TUNzR0ExVUVBd3drClFXUnRhWE56YVc5dUlFTnZiblJ5YjJ4c1pYSWdWMlZpYUc5dmF5QkVaVzF2SUVOQk1JSUJJakFOQmdrcWhraUcKOXcwQkFRRUZBQU9DQVE4QU1JSUJDZ0tDQVFFQXRRcEhKdUZQT3NqalNFbjRUckNpdjBaNnZBRlpxV2c9PQotLS0tLUVORCBDRVJUSUZJQ0FURS0tLS0tCg==
  rules:
  - operations: ["CREATE", "UPDATE"]
    apiGroups: ["apps"]
    apiVersions: ["v1"]
    resources: ["deployments"]
  namespaceSelector:
    matchExpressions:
    - key: environment
      operator: NotIn
      values: ["kube-system", "kube-public"]
  admissionReviewVersions: ["v1"]
  sideEffects: None
  timeoutSeconds: 5
  failurePolicy: Fail
EOF
```{{exec}}

```bash
kubectl create namespace test-app
kubectl create deployment nginx --image=nginx -n test-app
kubectl create namespace prod-app
kubectl label namespace prod-app environment=kube-system
kubectl create deployment nginx --image=nginx -n prod-app
```{{exec}}

Unlabeled namespaces are blocked; exempted ones proceed.
