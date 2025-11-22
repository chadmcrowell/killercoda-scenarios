<br>

### Storage finally arrives

**Key observations**

✅ Pending PVCs stay quiet until you inspect events.  
✅ `WaitForFirstConsumer` delays binding until a pod lands on a node—great for multi-zone clusters.  
✅ `Retain` preserves data but leaves PVs in `Released` and manual cleanup is required.  
✅ Access modes matter; many provisioners only handle `ReadWriteOnce`.

**Production patterns**

Multi-zone safe storage:

```yaml
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: zone-aware
provisioner: kubernetes.io/aws-ebs
volumeBindingMode: WaitForFirstConsumer
allowedTopologies:
- matchLabelExpressions:
  - key: topology.kubernetes.io/zone
    values:
    - us-east-1a
    - us-east-1b
```

Expand an existing PVC (if supported):

```yaml
spec:
  resources:
    requests:
      storage: 10Gi  # Increase from original size
```

StatefulSet with `volumeClaimTemplates`:

```yaml
volumeClaimTemplates:
- metadata:
    name: data
  spec:
    accessModes: ["ReadWriteOnce"]
    storageClassName: fast-ssd
    resources:
      requests:
        storage: 100Gi
```

**Cleanup**

```bash
kubectl delete pod storage-app consumer-app 2>/dev/null
kubectl delete pvc broken-pvc delayed-pvc retain-pvc shared-pvc 2>/dev/null
kubectl delete storageclass super-fast-nvme delayed-binding retain-storage 2>/dev/null
kubectl delete pv --all 2>/dev/null
```{{exec}}

---

Next: Day 9 - ConfigMap Updates That Don't Reach Your Pods
