## Step 1: Check default token mounting

```bash
kubectl run default-token --image=nginx --dry-run=client -o yaml | grep -A 5 serviceAccount
```{{exec}}

```bash
kubectl run default-token --image=nginx
kubectl exec default-token -- ls /var/run/secrets/kubernetes.io/serviceaccount/
```{{exec}}

Default ServiceAccount auto-mounts ca.crt, namespace, and token files.
