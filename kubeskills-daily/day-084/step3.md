## Step 3: Create Ingress without controller

```bash
cat <<EOF | kubectl apply -f -
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: broken-ingress
spec:
  rules:
  - host: example.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: web-service
            port:
              number: 80
EOF

sleep 10
```{{exec}}

```bash
kubectl get ingress broken-ingress

echo ""
echo "Ingress has no ADDRESS (no controller to provision it)"
kubectl describe ingress broken-ingress | grep -A 5 "Events:"
```{{exec}}

Without a controller, the Ingress object is accepted by the API server but never acted on — the ADDRESS field stays empty and no traffic ever reaches the backend.
