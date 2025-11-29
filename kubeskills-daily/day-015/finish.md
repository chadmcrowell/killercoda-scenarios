<br>

### Paths in order now

**Key observations**

✅ Prefix is greedy—earlier rules steal traffic; longest prefixes belong first.  
✅ Exact matching is strict; trailing slashes or casing break routes.  
✅ ImplementationSpecific varies by controller; nginx needs the regex annotation.  
✅ Multiple Ingress objects with the same host merge rules—watch for collisions.  
✅ Inspect controller config/logs to prove how paths are compiled.

**Production patterns**

API versioning with correct ordering:

```yaml
paths:
- path: /api/v3
  pathType: Prefix
  backend:
    service:
      name: api-v3
- path: /api/v2
  pathType: Prefix
  backend:
    service:
      name: api-v2
- path: /api
  pathType: Prefix
  backend:
    service:
      name: api-v1
```

Microservices routing:

```yaml
paths:
- path: /users
  pathType: Prefix
  backend:
    service:
      name: user-service
- path: /orders
  pathType: Prefix
  backend:
    service:
      name: order-service
- path: /
  pathType: Prefix
  backend:
    service:
      name: frontend
```

Regex for dynamic routes:

```yaml
metadata:
  annotations:
    nginx.ingress.kubernetes.io/use-regex: "true"
spec:
  rules:
  - http:
      paths:
      - path: /api/v[0-9]+/.*
        pathType: ImplementationSpecific
```

**Cleanup**

```bash
pkill -f "port-forward.*ingress-nginx" 2>/dev/null
kubectl delete ingress --all
kubectl delete deployment api-v1 api-v2
kubectl delete service api-v1-svc api-v2-svc
```{{exec}}

---

Next: Day 16 - RBAC Permission Denied Debugging
