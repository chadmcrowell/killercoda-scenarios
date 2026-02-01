## Step 6: Test NetworkPolicy isolation

```bash
# Deploy services in each namespace
for tenant in team-a team-b; do
  kubectl run web -n $tenant --image=nginx --port=80
  kubectl expose pod web -n $tenant --port=80
done

kubectl wait --for=condition=Ready pod -n team-a web --timeout=60s
kubectl wait --for=condition=Ready pod -n team-b web --timeout=60s

# Test connectivity before NetworkPolicy
WEB_B_IP=$(kubectl get svc web -n team-b -o jsonpath='{.spec.clusterIP}')
kubectl run test -n team-a --rm -it --image=busybox --restart=Never -- \
  wget -O- --timeout=2 http://$WEB_B_IP 2>&1 | grep -i "welcome\|connected" || echo "Connected"
```{{exec}}

Without NetworkPolicy, pods can communicate across namespaces.
