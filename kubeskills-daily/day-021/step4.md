## Step 4: Test namespace with finalizer

```bash
kubectl create namespace stuck-namespace
kubectl patch namespace stuck-namespace -p '{"metadata":{"finalizers":["example.com/stuck"]}}'
```{{exec}}

```bash
kubectl delete namespace stuck-namespace
kubectl get namespace stuck-namespace
kubectl get namespace stuck-namespace -o yaml | grep -A 5 status
```{{exec}}

Namespace remains Terminating due to finalizer.
