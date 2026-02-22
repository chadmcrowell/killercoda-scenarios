## Step 9: Test annotation incompatibility

```bash
cat <<EOF | kubectl apply -f -
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: nginx-annotations
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
    nginx.ingress.kubernetes.io/ssl-redirect: "true"
spec:
  rules:
  - host: example.com
    http:
      paths:
      - path: /app
        pathType: Prefix
        backend:
          service:
            name: web-service
            port:
              number: 80
EOF

echo "Annotation incompatibility:"
echo "- nginx.ingress.kubernetes.io/* only for nginx"
echo "- traefik.ingress.kubernetes.io/* only for Traefik"
echo "- alb.ingress.kubernetes.io/* only for AWS ALB"
echo "- Wrong annotations = ignored or errors"
```{{exec}}

Ingress annotations are controller-specific — `nginx.ingress.kubernetes.io/*` annotations are silently ignored by Traefik, HAProxy, or ALB controllers. This is a common misconfiguration when migrating between controllers.
