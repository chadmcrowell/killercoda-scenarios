## Step 6: Test cross-namespace access (allowed by default!)

```bash
kubectl run -it --rm test -n team-a --image=curlimages/curl -- curl -m 5 http://app-b-svc.team-b.svc.cluster.local
```{{exec}}

Should succeed because cross-namespace traffic is allowed by default.
