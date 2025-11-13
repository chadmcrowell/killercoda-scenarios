<br>

### Init mastery unlocked

**Key observations**

✅ Init containers run sequentially and block the main app until each succeeds.
✅ Pod-level `restartPolicy` dictates whether failed init containers retry.
✅ No built-in timeout—implement your own retry + exit strategy.
✅ Sidecars (K8s 1.28+) live in `initContainers` with `restartPolicy: Always`.

**Production patterns**

DB connection gate:

```yaml
initContainers:
- name: wait-for-postgres
  image: postgres:15
  command:
  - sh
  - -c
  - |
    for i in $(seq 1 30); do
      if pg_isready -h postgres-svc -p 5432; then exit 0; fi
      sleep 2
    done
    exit 1
```

Fetch remote config:

```yaml
initContainers:
- name: fetch-config
  image: curlimages/curl
  command:
  - sh
  - -c
  - curl -o /config/app.conf https://config-server/app.conf
  volumeMounts:
  - name: config
    mountPath: /config
```

Run database migrations before app start:

```yaml
initContainers:
- name: db-migrate
  image: migrate/migrate
  command:
  - migrate
  - -path=/migrations
  - -database=postgres://...
  - up
```

**Cleanup**

```bash
kubectl delete pod blocked-pod fixed-pod no-restart-pod multi-init sidecar-demo
```{{exec}}

---

Next: [Week 2 preview - Liveness probe death loops, init container failures, and PVC binding chaos](https://github.com/kubeskills/daily)
