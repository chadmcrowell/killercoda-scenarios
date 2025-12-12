## Step 8: Test cross-namespace access again (blocked!)

```bash
kubectl run -it --rm test -n team-a --image=curlimages/curl -- curl -m 5 http://app-b-svc.team-b.svc.cluster.local 2>&1 || echo "Blocked!"
```{{exec}}

Should time out or fail—NetworkPolicy blocked cross-namespace traffic.
