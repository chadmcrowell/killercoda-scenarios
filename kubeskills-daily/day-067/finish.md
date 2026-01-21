<br>

### Init container lessons

**Key observations**

- Init containers run sequentially.
- Main containers wait until all init containers succeed.
- Init containers restart on failure unless restartPolicy is Never.
- Init containers can share volumes with main containers.
- Init container logs require container selection.
- Sidecar init containers can run alongside the app (K8s 1.28+).

**Production patterns**

```yaml
apiVersion: apps/v1
kind: Deployment
spec:
  template:
    spec:
      initContainers:
      - name: db-migration
        image: myapp:v1.0
        command:
        - sh
        - -c
        - |
          echo "Running database migrations..."
          ./migrate --database=$DB_URL up
          echo "Migrations complete!"
        env:
        - name: DB_URL
          valueFrom:
            secretKeyRef:
              name: db-credentials
              key: url
      containers:
      - name: app
        image: myapp:v1.0
```

```yaml
initContainers:
- name: wait-for-db
  image: busybox:1.36
  command:
  - sh
  - -c
  - |
    until nc -z postgres 5432; do
      echo "Waiting for postgres..."
      sleep 2
    done
    echo "Postgres is ready!"
- name: wait-for-redis
  image: busybox:1.36
  command:
  - sh
  - -c
  - |
    until nc -z redis 6379; do
      echo "Waiting for redis..."
      sleep 2
    done
    echo "Redis is ready!"
```

```yaml
initContainers:
- name: prepare-config
  image: busybox
  command:
  - sh
  - -c
  - |
    cat > /config/app.conf <<EOF
    server_name=$(hostname)
    timestamp=$(date)
    environment=$ENVIRONMENT
    EOF
  env:
  - name: ENVIRONMENT
    value: "production"
  volumeMounts:
  - name: config
    mountPath: /config
containers:
- name: app
  image: myapp:v1.0
  volumeMounts:
  - name: config
    mountPath: /etc/app
volumes:
- name: config
  emptyDir: {}
```

**Cleanup**

```bash
kubectl delete pod init-success init-fail init-crashloop init-timeout init-dependency init-volume init-resources init-never-restart with-sidecar init-secret init-sequence init-with-probe
kubectl delete service mysql
kubectl delete secret db-creds
rm -f /tmp/init-diagnosis.sh
```{{exec}}

---

Next: Day 68 - Job and CronJob Failures
