## Step 14: Test namespace-scoped secrets

```bash
# Create secret in Team A
kubectl create secret generic team-a-secret -n team-a --from-literal=key=valueA

# Try to access from Team B
kubectl run -it --rm test -n team-b --image=busybox -- sh -c 'ls /var/run/secrets/kubernetes.io/serviceaccount/'
```{{exec}}

Secrets are scoped per namespace; Team B cannot read Team A's secrets.
