## Step 12: Verify token expiration behavior

```bash
SHORT_TOKEN=$(kubectl create token default --duration=60s)
```{{exec}}

```bash
kubectl --token=$SHORT_TOKEN get pods
sleep 90
kubectl --token=$SHORT_TOKEN get pods
```{{exec}}

First call works; after expiration the token is rejected.
