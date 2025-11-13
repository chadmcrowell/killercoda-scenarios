## Step 7: View active policies

```bash
kubectl get networkpolicies
```{{exec}}

```bash
kubectl describe networkpolicy allow-web-ingress
```{{exec}}

Remember: policies are namespace-scoped and additive—multiple matching rules combine.
