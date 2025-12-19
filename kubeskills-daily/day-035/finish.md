<br>

### Init container dependency lessons

**Key observations**

- Sequential execution: init containers always run in order before the main container.
- Blocking behavior: a bad init (crash or infinite wait) stops the pod forever.
- Circular dependencies: mutual waits cause permanent deadlocks until you break the cycle.
- Timeouts and retries: cap waits or persist state to survive transient failures.
- Ordering tricks: StatefulSets can gate each ordinal on its predecessor.

**Production patterns**

```yaml
initContainers:
- name: wait-for-db
  image: busybox
  command: ['sh', '-c']
  args:
  - |
    timeout 300 sh -c 'until nc -z postgres 5432; do sleep 2; done' || {
      echo "Timeout waiting for postgres, starting anyway"
      exit 0
    }
```

```yaml
initContainers:
- name: run-migrations
  image: myapp:migrations
  command: ['./migrate', 'up']
  env:
  - name: DATABASE_URL
    valueFrom:
      secretKeyRef:
        name: db-credentials
        key: url
```

```yaml
initContainers:
- name: fetch-config
  image: curlimages/curl
  command: ['sh', '-c']
  args:
  - curl -o /config/app.yaml https://config-server/app/prod
  volumeMounts:
  - name: config
    mountPath: /config
containers:
- name: app
  volumeMounts:
  - name: config
    mountPath: /app/config
volumes:
- name: config
  emptyDir: {}
```

```yaml
initContainers:
- name: wait-for-master
  image: busybox
  command: ['sh', '-c']
  args:
  - |
    if [ "${HOSTNAME##*-}" = "0" ]; then
      echo "I am the master"
      exit 0
    fi
    until nslookup ${STATEFUL_SET_NAME}-0.${SERVICE_NAME}; do
      sleep 2
    done
```

**Cleanup**

```bash
kubectl delete deployment service-a service-b safe-dependency
kubectl delete service service-a service-b
kubectl delete pod init-timeout-test multi-init init-fail init-retry readiness-vs-init
kubectl delete job job-with-init
kubectl delete statefulset stateful-init
kubectl delete service stateful-init
kubectl delete configmap startup-script
```{{exec}}

---

Next: Day 36 - Job Completion and Backoff Limits
