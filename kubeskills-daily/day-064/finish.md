<br>

### PV provisioning failure lessons

**Key observations**

- StorageClass is required for dynamic provisioning.
- The provisioner must exist or PVCs remain Pending.
- Access modes must match between PV and PVC.
- Volume limits exist per cloud provider.
- ReclaimPolicy controls delete vs retain behavior.
- WaitForFirstConsumer delays binding until scheduling.

**Production patterns**

```yaml
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: fast-ssd
  annotations:
    storageclass.kubernetes.io/is-default-class: "false"
provisioner: kubernetes.io/aws-ebs
parameters:
  type: gp3
  iops: "3000"
  throughput: "125"
  encrypted: "true"
  kmsKeyId: arn:aws:kms:us-east-1:123456789:key/...
volumeBindingMode: WaitForFirstConsumer
allowVolumeExpansion: true
reclaimPolicy: Retain  # Don't delete on PVC deletion
```

```yaml
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: database
spec:
  serviceName: database
  replicas: 3
  selector:
    matchLabels:
      app: database
  template:
    metadata:
      labels:
        app: database
    spec:
      containers:
      - name: postgres
        image: postgres:15
        volumeMounts:
        - name: pgdata
          mountPath: /var/lib/postgresql/data
  volumeClaimTemplates:
  - metadata:
      name: pgdata
    spec:
      accessModes: ["ReadWriteOnce"]
      storageClassName: fast-ssd
      resources:
        requests:
          storage: 100Gi
```

```yaml
# Prometheus alerts
- alert: PVCPendingTooLong
  expr: |
    kube_persistentvolumeclaim_status_phase{phase="Pending"} == 1
  for: 10m
  annotations:
    summary: "PVC {{ $labels.namespace }}/{{ $labels.persistentvolumeclaim }} pending > 10min"

- alert: VolumeAttachmentFailed
  expr: |
    kube_pod_status_phase{phase="Pending"} == 1
  for: 15m
  annotations:
    summary: "Pod {{ $labels.namespace }}/{{ $labels.pod }} stuck pending"

- alert: StorageNearFull
  expr: |
    (kubelet_volume_stats_used_bytes / kubelet_volume_stats_capacity_bytes) > 0.9
  annotations:
    summary: "Volume {{ $labels.persistentvolumeclaim }} > 90% full"
```

**Cleanup**

```bash
kubectl delete pod pvc-pod wait-pod
kubectl delete pvc test-pvc broken-pvc huge-pvc mismatch-pvc block-pvc wait-pvc delete-pvc 2>/dev/null
kubectl delete pv readonly-pv wait-pv 2>/dev/null
kubectl delete statefulset broken-statefulset
kubectl delete service stateful-svc
kubectl delete storageclass broken-storage wait-for-consumer
rm -f /tmp/storage-diagnosis.sh
```{{exec}}

---

Next: Day 65 - Image Pull Failures and Registry Issues
