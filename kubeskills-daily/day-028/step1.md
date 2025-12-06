## Step 1: Check PSA availability

```bash
kubectl explain pod.spec.securityContext
kubectl api-versions | grep admission
```{{exec}}

PSA is enabled by default in Kubernetes 1.23+.
