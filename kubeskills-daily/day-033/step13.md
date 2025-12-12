## Step 13: Test retry configuration

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
    retries:
      attempts: 3
      perTryTimeout: 2s
      retryOn: 5xx,reset,connect-failure
VS
```
```{{exec}}

Configures retries for v1 subset.
