<br>

### Volume mount permission lessons

**Key observations**

- fsGroup sets group ownership on writable volumes so multiple users can write.
- runAsUser must align with volume permissions or writes fail.
- readOnly mounts (and Secrets/ConfigMaps) block writes regardless of user.
- subPath mounts can behave differently for ownership vs the parent mount.
- HostPath uses host permissions; non-root often fails on root-owned paths.
- Container-level securityContext overrides pod-level defaults.

**Production patterns**

```yaml
apiVersion: v1
kind: Pod
spec:
  securityContext:
    runAsNonRoot: true
    runAsUser: 1000
    fsGroup: 2000
    seccompProfile:
      type: RuntimeDefault
  containers:
  - name: app
    securityContext:
      allowPrivilegeEscalation: false
      capabilities:
        drop: ["ALL"]
    volumeMounts:
    - name: data
      mountPath: /app/data
  volumes:
  - name: data
    emptyDir: {}
```

```yaml
initContainers:
- name: fix-permissions
  image: busybox
  command: ['sh', '-c', 'chown -R 1000:2000 /data && chmod -R 755 /data']
  securityContext:
    runAsUser: 0
  volumeMounts:
  - name: data
    mountPath: /data
```

```yaml
apiVersion: v1
kind: Pod
spec:
  securityContext:
    runAsUser: 999
    fsGroup: 999
  containers:
  - name: postgres
    image: postgres:15
    volumeMounts:
    - name: pgdata
      mountPath: /var/lib/postgresql/data
  volumes:
  - name: pgdata
    persistentVolumeClaim:
      claimName: postgres-pvc
```

**Cleanup**

```bash
kubectl delete pod emptydir-test nonroot-fail hostpath-denied fsgroup-fix readonly-mount subpath-test pvc-permissions shared-volume secret-volume projected-volume init-prepares-volume security-conflict volume-debug 2>/dev/null
kubectl delete pvc test-pvc 2>/dev/null
kubectl delete secret secret-test 2>/dev/null
kubectl delete configmap readonly-cm 2>/dev/null
```{{exec}}

---

Next: Day 38 - TBD
