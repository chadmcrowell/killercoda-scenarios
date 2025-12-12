## Step 8: Break routing - weights don't add to 100

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
        subset: v1
      weight: 90
    - destination:
        host: webapp
        subset: v2
      weight: 20  # Total = 110!
VS
```

```bash
kubectl run -it --rm debug --image=curlimages/curl --restart=Never -- curl -s http://webapp
```{{exec}}

Istio normalizes weights, so requests still work.
