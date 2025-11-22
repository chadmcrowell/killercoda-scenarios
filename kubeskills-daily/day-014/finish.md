<br>

### Quota-conscious now

**Key observations**

✅ Deployments can "succeed" while ReplicaSets fail under quota—check events.  
✅ Quotas require requests for quotaed resources; LimitRanges can inject defaults.  
✅ Hard pod limits cap replicas regardless of desired count.  
✅ Scopes and count quotas tailor limits by priority or object type.

**Production patterns**

Team namespace quota:

```yaml
apiVersion: v1
kind: ResourceQuota
metadata:
  name: team-quota
spec:
  hard:
    requests.cpu: "10"
    requests.memory: "20Gi"
    limits.cpu: "20"
    limits.memory: "40Gi"
    pods: "50"
    services: "20"
    persistentvolumeclaims: "10"
    secrets: "50"
    configmaps: "50"
```

Prevent LoadBalancer sprawl:

```yaml
apiVersion: v1
kind: ResourceQuota
metadata:
  name: no-loadbalancers
spec:
  hard:
    services.loadbalancers: "0"
    services.nodeports: "0"
```

LimitRange for safety:

```yaml
apiVersion: v1
kind: LimitRange
metadata:
  name: container-limits
spec:
  limits:
  - type: Container
    max:
      cpu: "2"
      memory: "4Gi"
    min:
      cpu: "50m"
      memory: "64Mi"
    default:
      cpu: "500m"
      memory: "512Mi"
    defaultRequest:
      cpu: "100m"
      memory: "128Mi"
  - type: PersistentVolumeClaim
    max:
      storage: "50Gi"
    min:
      storage: "1Gi"
```

**Cleanup**

```bash
kubectl delete namespace quota-test
```{{exec}}

---

🎉 Week 2 Complete! 14 days of Kubernetes failure modes mastered.
