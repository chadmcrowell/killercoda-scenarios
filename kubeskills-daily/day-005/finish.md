<br>

### Taints mastered

**Key observations**

✅ `NoExecute` immediately evicts non-tolerating pods.
✅ `NoSchedule` blocks new pods but keeps existing workloads.
✅ `tolerationSeconds` lets you delay eviction (spot instances, draining nodes, etc.).

**Production patterns**

Dedicated GPU nodes:

```yaml
tolerations:
- key: nvidia.com/gpu
  operator: Exists
  effect: NoSchedule
```

Tolerate spot instances with a 2-minute grace period:

```yaml
tolerations:
- key: spot
  operator: Equal
  value: "true"
  effect: NoExecute
  tolerationSeconds: 120
```

DaemonSets that must run everywhere:

```yaml
tolerations:
- operator: Exists
```

**Cleanup**

```bash
kubectl taint nodes $NODE dedicated=gpu:NoSchedule-
kubectl delete pod no-toleration with-toleration temporary-toleration test-pod
kubectl delete deployment nginx
```{{exec}}

---

Next: [Day 6 - Liveness probe death loops](https://github.com/kubeskills/daily)
