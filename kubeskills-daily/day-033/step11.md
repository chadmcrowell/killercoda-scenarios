## Step 11: Fix and test header-based routing

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
    - headers:
        x-version:
          exact: v2
    route:
    - destination:
        host: webapp
        subset: v2
  - route:
    - destination:
        host: webapp
        subset: v1
VS
```

```bash
kubectl run -it --rm debug --image=curlimages/curl --restart=Never -- curl -s http://webapp
kubectl run -it --rm debug --image=curlimages/curl --restart=Never -- curl -H "x-version: v2" -s http://webapp
```{{exec}}

Header routes v2 when x-version=v2; default goes to v1.
