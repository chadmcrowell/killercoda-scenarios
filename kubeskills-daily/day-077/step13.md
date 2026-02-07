## Step 13: Secret rotation without restart

```bash
# Update secret
kubectl create secret generic db-creds \
  --from-literal=username=admin \
  --from-literal=password=newsecret456 \
  --dry-run=client -o yaml | kubectl apply -f -

# Pods using env vars don't see update
kubectl exec env-secret-pod -- printenv | grep DB_PASSWORD

echo "Secret updated in cluster, but:"
echo "- Pods with env vars still have old value"
echo "- Must restart pod to get new secret"
echo "- Volume mounts update automatically (eventually)"
```{{exec}}

Secret rotation is invisible to pods using env vars - they require a restart to pick up new values.
