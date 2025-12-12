## Step 9: Break routing - missing subset

```bash
cat <<'VS' | kubectl apply -f -
apiVersion: networking.istio.io/v1beta1
kind: VirtualService
metadata:
  name: webapp
spec:
  hosts:
  - webapp
  http:
  - route:
    - destination:
        host: webapp
        subset: v3  # Doesn't exist!
      weight: 100
VS
```

```bash
kubectl run -it --rm debug --image=curlimages/curl --restart=Never -- curl -v http://webapp 2>&1 | grep -i "503\|error"
```{{exec}}

Missing subset leads to 503s.
