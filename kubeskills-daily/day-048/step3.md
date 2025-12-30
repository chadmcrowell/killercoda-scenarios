## Step 3: Test deprecated API versions

```bash
kubectl get deployments.v1.apps -A
kubectl get ingresses.v1.networking.k8s.io -A
# Older clusters might have v1beta1 versions
# kubectl get deployments.v1beta1.apps
# kubectl get ingresses.v1beta1.networking.k8s.io
```{{exec}}

See which API versions are in use now.
