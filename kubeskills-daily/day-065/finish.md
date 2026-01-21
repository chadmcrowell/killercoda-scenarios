<br>

### Image pull failure lessons

**Key observations**

- ImagePullBackOff uses exponential retry intervals.
- imagePullSecrets are required for private registries.
- Docker Hub enforces rate limits per IP.
- imagePullPolicy controls cache usage.
- :latest is mutable and risky for production.
- Nodes cache previously pulled images.

**Production patterns**

```yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: app-sa
  namespace: production
imagePullSecrets:
- name: production-registry
---
apiVersion: v1
kind: Secret
metadata:
  name: production-registry
  namespace: production
type: kubernetes.io/dockerconfigjson
data:
  .dockerconfigjson: <base64-encoded-docker-config>
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: myapp
  namespace: production
spec:
  replicas: 3
  template:
    spec:
      serviceAccountName: app-sa
      containers:
      - name: app
        image: myregistry.example.com/myapp:v1.2.3
        imagePullPolicy: IfNotPresent  # Use cache when available
```

```yaml
apiVersion: apps/v1
kind: Deployment
spec:
  template:
    spec:
      containers:
      - name: app
        # Pin to exact digest for immutability
        image: nginx@sha256:10d1f5b58f74683ad34eb29287e07dab1e90f10af243f151bb50aa5dbb4d62ee
```

```text
# For nodes to use registry mirror (reduce rate limit hits)
# /etc/containerd/config.toml
[plugins."io.containerd.grpc.v1.cri".registry.mirrors]
  [plugins."io.containerd.grpc.v1.cri".registry.mirrors."docker.io"]
    endpoint = ["https://registry-mirror.example.com"]
```

```yaml
# Prometheus alerts
- alert: ImagePullBackOff
  expr: |
    kube_pod_container_status_waiting_reason{reason="ImagePullBackOff"} > 0
  for: 10m
  annotations:
    summary: "Pod {{ $labels.namespace }}/{{ $labels.pod }} stuck pulling image"

- alert: HighImagePullFailureRate
  expr: |
    rate(kubelet_runtime_operations_errors_total{operation_type="pull_image"}[5m]) > 0.1
  annotations:
    summary: "High image pull failure rate on {{ $labels.node }}"

- alert: RegistryUnreachable
  expr: |
    probe_success{job="registry-monitor"} == 0
  for: 5m
  annotations:
    summary: "Container registry unreachable"
```

```yaml
# DaemonSet to pre-pull images on all nodes
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: image-prepull
  namespace: kube-system
spec:
  selector:
    matchLabels:
      app: image-prepull
  template:
    metadata:
      labels:
        app: image-prepull
    spec:
      initContainers:
      - name: prepull-app
        image: myregistry.example.com/myapp:v1.2.3
        command: ['sh', '-c', 'echo Image pulled']
      - name: prepull-db
        image: postgres:15-alpine
        command: ['sh', '-c', 'echo Image pulled']
      containers:
      - name: pause
        image: registry.k8s.io/pause:3.9
```

**Cleanup**

```bash
kubectl delete pod nonexistent wrong-registry private-image with-pull-secret always-pull never-pull no-tag digest-pin slow-pull sa-pull-secret
kubectl delete deployment rate-limit-test concurrent-pulls
kubectl delete secret my-registry-secret
kubectl delete serviceaccount registry-sa
rm -f /tmp/image-diagnosis.sh
```{{exec}}

---

Next: Day 66 - Resource Quota Violations and Limit Ranges
