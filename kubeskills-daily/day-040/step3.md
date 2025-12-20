## Step 3: Install cert-manager

```bash
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.13.0/cert-manager.yaml

kubectl wait --for=condition=Ready pods --all -n cert-manager --timeout=120s
```{{exec}}|skip{{sandbox}}

Install cert-manager CRDs and components, then wait for them to be ready.
