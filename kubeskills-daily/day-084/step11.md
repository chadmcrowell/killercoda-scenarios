## Step 11: Test backend without endpoints

```bash
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Service
metadata:
  name: no-endpoints-service
spec:
  selector:
    app: nonexistent
  ports:
  - port: 80
    targetPort: 8080
---
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: no-endpoints-ingress
spec:
  rules:
  - host: example.com
    http:
      paths:
      - path: /broken
        pathType: Prefix
        backend:
          service:
            name: no-endpoints-service
            port:
              number: 80
EOF

sleep 10
```{{exec}}

```bash
kubectl get endpoints no-endpoints-service

echo ""
echo "Service has no endpoints - traffic will 503"
```{{exec}}

A Service with no matching pods has an empty Endpoints object. The Ingress controller routes the request to the Service, which has nowhere to send it — resulting in a 503 response to the client.
