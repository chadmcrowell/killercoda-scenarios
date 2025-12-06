<br>

### etcd performance understood

**Key observations**

✅ etcd backs all cluster state; health and disk latency drive API performance.  
✅ DB bloat slows etcd; compact/defrag and keep size under control.  
✅ Heavy object counts (Secrets/ConfigMaps) inflate keyspace and size.  
✅ Regular snapshots are critical for recovery; monitor alarms like NOSPACE.  
✅ API latency reflects etcd health—watch metrics and request timings.

**Production patterns**

Automate backups:

```yaml
apiVersion: batch/v1
kind: CronJob
metadata:
  name: etcd-backup
  namespace: kube-system
spec:
  schedule: "0 2 * * *"
  jobTemplate:
    spec:
      template:
        spec:
          hostNetwork: true
          containers:
          - name: backup
            image: k8s.gcr.io/etcd:3.5.9-0
            command:
            - /bin/sh
            - -c
            - ETCDCTL_API=3 etcdctl snapshot save /backup/etcd-$(date +%Y%m%d).db
          volumeMounts:
          - name: etcd-certs
            mountPath: /etc/kubernetes/pki/etcd
          - name: backup
            mountPath: /backup
          volumes:
          - name: etcd-certs
            hostPath:
              path: /etc/kubernetes/pki/etcd
          - name: backup
            hostPath:
              path: /var/backups/etcd
          restartPolicy: OnFailure
```

Automate compaction:

```bash
0 3 * * * etcdctl compact $(etcdctl endpoint status --write-out="json" | jq -r '.[0].Status.header.revision - 1000')
```

Monitor latency:

```bash
etcd_disk_backend_commit_duration_seconds_bucket{le="0.1"} < 0.99
```

**Cleanup**

```bash
kubectl delete configmap $(kubectl get cm -o name | grep test-) 2>/dev/null
kubectl delete secret $(kubectl get secret -o name | grep load-secret-) 2>/dev/null
rm -f ./etcd-backup.db
```{{exec}}

---

Next: Day 26 - Kubelet Eviction Thresholds
