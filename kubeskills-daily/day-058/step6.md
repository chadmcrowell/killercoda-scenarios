## Step 6: Test wrong port number

```bash
cat <<EOF | kubectl apply -f -
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: wrong-port
spec:
  ingressClassName: nginx
  rules:
  - host: port.example.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: app-v1-svc
            port:
              number: 8080  # Wrong! Service is on port 80
EOF
```

**Test (returns 503):**
```bash
INGRESS_IP=$(kubectl get svc -n ingress-nginx ingress-nginx-controller -o jsonpath='{.status.loadBalancer.ingress[0].ip}' 2>/dev/null || echo "localhost")
curl -H "Host: port.example.com" http://$INGRESS_IP/ 2>&1 || echo "503 Service Unavailable"
```

Wrong service port yields 503 from the controller.
