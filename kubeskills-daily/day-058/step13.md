## Step 13: Check Ingress controller logs

```bash
# Get controller pod
CONTROLLER_POD=$(kubectl get pods -n ingress-nginx -l app.kubernetes.io/component=controller -o jsonpath='{.items[0].metadata.name}')

# Check logs for errors
kubectl logs -n ingress-nginx $CONTROLLER_POD --tail=50 | grep -i "error\|warn"
```{{exec}}

Controller logs reveal bad routes and config errors.
