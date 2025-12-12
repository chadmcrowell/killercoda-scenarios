## Step 12: Test conflicting rules (first match wins)

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
  - match:
    - uri:
        prefix: /api
    route:
    - destination:
        host: webapp
        subset: v2
  - match:
    - uri:
        prefix: /  # Catches everything!
    route:
    - destination:
        host: webapp
        subset: v1
VS
```

Order matters; first matching rule wins.
