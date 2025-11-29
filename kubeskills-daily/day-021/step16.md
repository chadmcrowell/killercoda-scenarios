## Step 16: Cleanup stuck namespace (production scenario)

```bash
kubectl create namespace cleanup-test
kubectl create configmap test1 -n cleanup-test
kubectl create configmap test2 -n cleanup-test --dry-run=client -o yaml | kubectl apply -f - --namespace=cleanup-test
kubectl patch namespace cleanup-test -p '{"metadata":{"finalizers":["stuck.finalizer.com"]}}'
```{{exec}}

```bash
kubectl delete namespace cleanup-test
kubectl get namespace cleanup-test
```{{exec}}

```bash
kubectl patch namespace cleanup-test -p '{"metadata":{"finalizers":[]}}' --type=merge
# Alternative raw finalize endpoint (advanced):
# kubectl get namespace cleanup-test -o json | jq '.metadata.finalizers = []' | kubectl replace --raw /api/v1/namespaces/cleanup-test/finalize -f -
```{{exec}}

Namespace deletes once finalizers are removed.
