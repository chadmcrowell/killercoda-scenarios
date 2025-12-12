## Step 9: Test from within Team B (allowed)

```bash
kubectl run -it --rm test -n team-b --image=curlimages/curl -- curl -m 5 http://app-b-svc
```{{exec}}

Same-namespace traffic should still work.
