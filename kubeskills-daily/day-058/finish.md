<br>

### Ingress routing lessons

**Key observations**

- IngressClass is required for controllers to pick up Ingresses.
- Service ports must match backend port definitions.
- Path types change match behavior (Prefix vs Exact).
- TLS secrets must exist in the same namespace.
- Conflicting Ingresses on the same host lead to surprises.
- Controller annotations are implementation-specific.

**Production patterns**

```yaml
# Complete Ingress with TLS
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: production-ingress
  annotations:
    nginx.ingress.kubernetes.io/ssl-redirect: "true"
    nginx.ingress.kubernetes.io/force-ssl-redirect: "true"
    cert-manager.io/cluster-issuer: "letsencrypt-prod"
spec:
  ingressClassName: nginx
  tls:
  - hosts:
    - app.example.com
    secretName: app-tls
  rules:
  - host: app.example.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: app-service
            port:
              number: 80
```

```yaml
# Multi-path routing
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: multi-service
spec:
  ingressClassName: nginx
  rules:
  - host: api.example.com
    http:
      paths:
      - path: /v1
        pathType: Prefix
        backend:
          service:
            name: api-v1
            port:
              number: 80
      - path: /v2
        pathType: Prefix
        backend:
          service:
            name: api-v2
            port:
              number: 80
      - path: /health
        pathType: Exact
        backend:
          service:
            name: health-check
            port:
              number: 8080
```

```yaml
# Rate limiting
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: rate-limited
  annotations:
    nginx.ingress.kubernetes.io/limit-rps: "10"
    nginx.ingress.kubernetes.io/limit-connections: "5"
spec:
  ingressClassName: nginx
  rules:
  - host: api.example.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: api-service
            port:
              number: 80
```

**Cleanup**

```bash
kubectl delete ingress --all
kubectl delete deployment app-v1 app-v2 default-backend
kubectl delete service app-v1-svc app-v2-svc default-backend-svc
kubectl delete secret tls-secret
kubectl delete namespace other-ns ingress-nginx
rm -f /tmp/tls.key /tmp/tls.crt
```{{exec}}

---

Next: Day 59 - TBD
