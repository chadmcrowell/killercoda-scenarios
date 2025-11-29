## Step 8: Token request API (programmatic)

```bash
kubectl create sa token-requester
```{{exec}}

```bash
kubectl create token token-requester --duration=10m
```{{exec}}

```bash
TOKEN=$(kubectl create token token-requester --duration=1h)
kubectl --token=$TOKEN get pods
```{{exec}}

Token request API returns short-lived tokens on demand.
