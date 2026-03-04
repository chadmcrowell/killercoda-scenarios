# Step 1 — Investigate the Problem

The infrastructure team left the cluster in a partially-migrated state. Simulate that state, then deploy the three broken Deployments and observe the outcome.

## Set Up the Cluster State

The migration applied some labels and left a maintenance taint on `node01`. Apply that state now:

```bash
kubectl label node node01 disktype=ssd
kubectl taint node node01 maintenance=true:NoSchedule
```{{exec}}

Confirm the current state of `node01`:

```bash
kubectl describe node node01 | grep -E "Taints:|Labels:" -A10 | head -20
```{{exec}}

Note what labels exist and what taint is present. You'll need this information in Step 2.

## Deploy the Three Workloads

**`gpu-inference`** — targets nodes with GPU hardware:

```bash
cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: gpu-inference
  namespace: default
spec:
  replicas: 2
  selector:
    matchLabels:
      app: gpu-inference
  template:
    metadata:
      labels:
        app: gpu-inference
    spec:
      nodeSelector:
        hardware: gpu
      containers:
      - name: inference
        image: busybox:1.35
        command: ["sh", "-c", "echo Running GPU inference; sleep 3600"]
        resources:
          requests:
            cpu: "100m"
            memory: "64Mi"
EOF
```{{exec}}

**`fast-cache`** — targets nodes with NVMe storage:

```bash
cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: fast-cache
  namespace: default
spec:
  replicas: 1
  selector:
    matchLabels:
      app: fast-cache
  template:
    metadata:
      labels:
        app: fast-cache
    spec:
      nodeSelector:
        disktype: nvme
      containers:
      - name: cache
        image: busybox:1.35
        command: ["sh", "-c", "echo Running fast cache; sleep 3600"]
        resources:
          requests:
            cpu: "50m"
            memory: "32Mi"
EOF
```{{exec}}

**`data-processor`** — targets batch workload nodes:

```bash
cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: data-processor
  namespace: default
spec:
  replicas: 1
  selector:
    matchLabels:
      app: data-processor
  template:
    metadata:
      labels:
        app: data-processor
    spec:
      nodeSelector:
        workload: batch
      containers:
      - name: processor
        image: busybox:1.35
        command: ["sh", "-c", "echo Running data processor; sleep 3600"]
        resources:
          requests:
            cpu: "200m"
            memory: "128Mi"
EOF
```{{exec}}

## Observe the Cluster State

Check all pod statuses:

```bash
kubectl get pods -o wide
```{{exec}}

Every pod across all three Deployments is `Pending`. No node column, no IP — the scheduler hasn't placed a single one.

Check the Deployment summary:

```bash
kubectl get deployments
```{{exec}}

```text
NAME             READY   UP-TO-DATE   AVAILABLE
data-processor   0/1     1            0
fast-cache       0/1     1            0
gpu-inference    0/2     2            0
```

Four pods, four failures. Your job is to find out why each one is blocked — and the answer is different for each Deployment.

Scan for FailedScheduling events:

```bash
kubectl get events --sort-by=.lastTimestamp --field-selector reason=FailedScheduling
```{{exec}}

All four pods report scheduling failures. The event messages contain the clues you need for Step 2.
