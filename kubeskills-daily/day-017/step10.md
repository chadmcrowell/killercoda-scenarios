## Step 10: Debug webhook failures

```bash
kubectl logs -n kube-system -l component=kube-apiserver --tail=50
```{{exec}}

```bash
kubectl run webhook-test --rm -it --restart=Never --image=curlimages/curl -- \
  curl -k https://webhook-svc.default.svc:443/validate
```{{exec}}

Check API server logs and hit the webhook directly to debug outages.
