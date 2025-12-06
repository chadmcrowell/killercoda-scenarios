## Step 8: Test with different user identities

```bash
kubectl create serviceaccount api-user
USER_TOKEN=$(kubectl create token api-user --duration=1h)

kubectl --token=$USER_TOKEN get pods --request-timeout=5s
```{{exec}}

ServiceAccount requests can hit different FlowSchemas than your user.
