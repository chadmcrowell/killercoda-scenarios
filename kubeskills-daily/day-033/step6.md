## Step 6: Create DestinationRule (define subsets)

```bash
cat <<'DR' | kubectl apply -f -
apiVersion: networking.istio.io/v1beta1
kind: DestinationRule
metadata:
  name: webapp
spec:
  host: webapp
  subsets:
  - name: v1
    labels:
      version: v1
  - name: v2
    labels:
      version: v2
DR
```

Subsets map labels for routing decisions.
