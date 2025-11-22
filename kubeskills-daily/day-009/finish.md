<br>

### Config keeps drifting until you restart

**Key observations**

✅ Environment variables are frozen at pod creation—restart to reload.  
✅ Volume mounts refresh on the kubelet sync loop (~60s).  
✅ subPath mounts are one-time copies; they never update.  
✅ Deployments do not watch ConfigMaps—add a hash or use a reloader.

**Production patterns**

Sidecar for config reload:

```yaml
containers:
- name: config-reloader
  image: jimmidyson/configmap-reload:v0.5.0
  args:
  - --volume-dir=/config
  - --webhook-url=http://localhost:8080/-/reload
  volumeMounts:
  - name: config
    mountPath: /config
```

Reloader operator (auto-restart):

```yaml
metadata:
  annotations:
    reloader.stakater.com/auto: "true"
```

**Cleanup**

```bash
kubectl delete deployment config-app kustomize-app 2>/dev/null
kubectl delete pod config-test subpath-test 2>/dev/null
kubectl delete configmap app-config 2>/dev/null
cd ~ && rm -rf /tmp/kustomize-demo
```{{exec}}

---

Next: Day 10 - Secret Rotation Without Restarts
