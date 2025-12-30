## Step 11: Test list vs get performance

```bash
time kubectl get pods -A > /dev/null
time kubectl get pod kube-apiserver-controlplane -n kube-system > /dev/null
```{{exec}}

Listing is heavier than a single get.
