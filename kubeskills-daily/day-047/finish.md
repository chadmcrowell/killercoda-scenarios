<br>

### StatefulSet orphaned PVC lessons

**Key observations**

- Scaling down or deleting StatefulSets does not delete PVCs by default; data persists.
- Scaling up reattaches pods to their original PVCs by ordinal.
- Foreground deletion still retains PVCs unless retention policy says otherwise (1.27+).
- Manual cleanup (or scripts) is needed to reclaim orphaned PVCs.
- podManagementPolicy and rollingUpdate partition change how pods start/update.
- Storage classes must support expansion for PVC resizing to succeed.

**Production patterns**

```yaml
persistentVolumeClaimRetentionPolicy:
  whenDeleted: Delete
  whenScaled: Retain
```

```yaml
updateStrategy:
  type: RollingUpdate
  rollingUpdate:
    partition: 8
```

```bash
# Script outline to find orphaned PVCs
for pvc in $(kubectl get pvc -o name); do
  pvc_name=${pvc#*/}
  if ! kubectl get pods -o json | jq -e \
       ".items[] | .spec.volumes[]? | .persistentVolumeClaim? | select(.claimName == \"$pvc_name\")" > /dev/null; then
    echo "Orphaned: $pvc_name"
  fi
done
```

**Cleanup**

```bash
kubectl delete statefulset --all
kubectl delete service stateful-svc 2>/dev/null
kubectl delete pvc --all
rm -f /tmp/find-orphan-pvcs.sh
```{{exec}}

---

Next: Day 48 - TBD
