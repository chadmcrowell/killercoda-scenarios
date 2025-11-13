<br>

### You survived the lockout

**Key observations**

✅ Default deny applies per-namespace; other namespaces stay open.
✅ DNS must be explicitly allowed (UDP 53 to `kube-system`).
✅ Both ingress *and* egress permissions are required for a full TCP handshake.

**Common production patterns**

Allow DNS everywhere:

```yaml
egress:
- to:
  - namespaceSelector:
      matchLabels:
        kubernetes.io/metadata.name: kube-system
  ports:
  - protocol: UDP
    port: 53
```

Allow health checks from ingress controllers:

```yaml
ingress:
- from:
  - namespaceSelector:
      matchLabels:
        name: ingress-nginx
```

Allow monitoring scrapes (Prometheus):

```yaml
ingress:
- from:
  - namespaceSelector:
      matchLabels:
        name: monitoring
  ports:
  - protocol: TCP
    port: 8080
```

**Cleanup**

```bash
kubectl delete networkpolicy --all
kubectl delete pod web client
```{{exec}}

---

Next: [Day 5 - Taints and Tolerations - Dedicated Node Failure](https://github.com/kubeskills/daily)
