## Step 7: Create VirtualService (90/10 split)

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
      weight: 10
VS
```

```bash
kubectl run -it --rm debug --image=curlimages/curl --restart=Never -- sh -c '
for i in $(seq 1 20); do
  curl -s http://webapp
done
' | grep -c "Version 1"
```{{exec}}

Expect ~18 v1 and ~2 v2 responses due to weights.
