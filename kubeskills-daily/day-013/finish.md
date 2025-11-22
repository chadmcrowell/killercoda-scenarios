<br>

### Drains unblocked (or not)

**Key observations**

✅ `minAvailable` vs `maxUnavailable` express availability in different ways.  
✅ Percentages adapt to replica count; strict values can block drains.  
✅ Single-replica + `minAvailable: 1` means no voluntary disruption allowed.  
✅ Multiple PDBs: the most restrictive wins.  
✅ PDBs only govern voluntary disruptions—crashes and forced deletes bypass them.

**Production patterns**

Stateless web app:

```yaml
apiVersion: policy/v1
kind: PodDisruptionBudget
metadata:
  name: web-pdb
spec:
  maxUnavailable: 25%
  selector:
    matchLabels:
      app: web
```

Database (strict):

```yaml
apiVersion: policy/v1
kind: PodDisruptionBudget
metadata:
  name: postgres-pdb
spec:
  minAvailable: 2  # Quorum for HA
  selector:
    matchLabels:
      app: postgres
```

Batch jobs (allow full disruption):

```yaml
apiVersion: policy/v1
kind: PodDisruptionBudget
metadata:
  name: batch-pdb
spec:
  maxUnavailable: 100%  # Jobs can be restarted
  selector:
    matchLabels:
      app: batch-processor
```

**Cleanup**

```bash
kubectl uncordon $(kubectl get nodes -o jsonpath='{.items[*].metadata.name}')
kubectl delete pdb critical-app-pdb single-replica-pdb unhealthy-pdb pdb-conflict 2>/dev/null
kubectl delete deployment critical-app 2>/dev/null
```{{exec}}

---

Next: Day 14 - ResourceQuota Limits
