## Step 5: Create a proper docker-registry secret

```bash
kubectl create secret docker-registry correct-pull-secret \
  --docker-server=private-registry.example.com \
  --docker-username=myuser \
  --docker-password=mypassword \
  --docker-email=user@example.com
```{{exec}}

```bash
kubectl get secret correct-pull-secret -o yaml
```{{exec}}

```bash
kubectl get secret correct-pull-secret -o jsonpath='{.data.\\.dockerconfigjson}' | base64 -d | jq .
```{{exec}}

This uses the kubernetes.io/dockerconfigjson format with an auth token entry.
