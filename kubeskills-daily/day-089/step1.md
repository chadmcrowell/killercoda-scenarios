# Step 1 — Investigate the Problem

Three Deployments are configured with node affinity rules. Deploy them and observe what the scheduler does with each one.

## Deploy the Three Workloads

**`gpu-worker`** — requires a node with `accelerator=nvidia-gpu`:

```bash
cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: gpu-worker
  namespace: default
spec:
  replicas: 2
  selector:
    matchLabels:
      app: gpu-worker
  template:
    metadata:
      labels:
        app: gpu-worker
    spec:
      affinity:
        nodeAffinity:
          requiredDuringSchedulingIgnoredDuringExecution:
            nodeSelectorTerms:
            - matchExpressions:
              - key: accelerator
                operator: In
                values:
                - nvidia-gpu
      containers:
      - name: worker
        image: busybox:1.35
        command: ["sh", "-c", "echo GPU worker running; sleep 3600"]
EOF
```{{exec}}

**`cache-server`** — requires a node in `zone=us-east-1a`:

```bash
cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: cache-server
  namespace: default
spec:
  replicas: 1
  selector:
    matchLabels:
      app: cache-server
  template:
    metadata:
      labels:
        app: cache-server
    spec:
      affinity:
        nodeAffinity:
          requiredDuringSchedulingIgnoredDuringExecution:
            nodeSelectorTerms:
            - matchExpressions:
              - key: zone
                operator: In
                values:
                - us-east-1a
      containers:
      - name: cache
        image: busybox:1.35
        command: ["sh", "-c", "echo Cache server running; sleep 3600"]
EOF
```{{exec}}

**`web-frontend`** — *prefers* a node with `tier=frontend` but doesn't require it:

```bash
cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: web-frontend
  namespace: default
spec:
  replicas: 1
  selector:
    matchLabels:
      app: web-frontend
  template:
    metadata:
      labels:
        app: web-frontend
    spec:
      affinity:
        nodeAffinity:
          preferredDuringSchedulingIgnoredDuringExecution:
          - weight: 100
            preference:
              matchExpressions:
              - key: tier
                operator: In
                values:
                - frontend
      containers:
      - name: frontend
        image: nginx:1.25
EOF
```{{exec}}

## Observe the Scheduling Outcomes

Wait a few seconds and check pod status across all three Deployments:

```bash
kubectl get pods -o wide
```{{exec}}

You should see three different outcomes:

```text
NAME                           READY   STATUS    NODE
cache-server-xxx               0/1     Pending   <none>
gpu-worker-xxx                 0/1     Pending   <none>
gpu-worker-yyy                 0/1     Pending   <none>
web-frontend-xxx               1/1     Running   node01
```

`gpu-worker` and `cache-server` pods are stuck in `Pending` — the scheduler cannot find a node that satisfies their affinity rules. `web-frontend` is `Running` even though no node has `tier=frontend`.

Check the Deployment summary to confirm DESIRED vs AVAILABLE:

```bash
kubectl get deployments
```{{exec}}

```text
NAME           READY   UP-TO-DATE   AVAILABLE
cache-server   0/1     1            0
gpu-worker     0/2     2            0
web-frontend   1/1     1            1
```

Two Deployments are completely unavailable. One is running but landed somewhere unintended.
