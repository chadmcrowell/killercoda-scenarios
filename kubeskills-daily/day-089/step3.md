# Step 3 — Apply the Fix

Label the worker node to satisfy each Deployment's affinity rules, verify correct placement, then build a combined required + preferred affinity spec.

## Fix 1 — gpu-worker: Label node01 as a GPU Node

Add the `accelerator=nvidia-gpu` label to `node01` to satisfy the hard affinity requirement:

```bash
kubectl label node node01 accelerator=nvidia-gpu
```{{exec}}

Confirm the label is applied:

```bash
kubectl get nodes -l accelerator=nvidia-gpu
```{{exec}}

The scheduler reconciles continuously. Watch the `gpu-worker` pods move from Pending to Running:

```bash
kubectl get pods -l app=gpu-worker -o wide -w
```{{exec}}

Press `Ctrl+C` once both pods are `Running`. Both should be on `node01` — the only node with `accelerator=nvidia-gpu`.

## Fix 2 — cache-server: Label node01 with the Zone

Add the `zone=us-east-1a` label to `node01`:

```bash
kubectl label node node01 zone=us-east-1a
```{{exec}}

Watch the `cache-server` pod schedule:

```bash
kubectl get pods -l app=cache-server -o wide -w
```{{exec}}

Press `Ctrl+C` once it's `Running`. Confirm it landed on `node01`.

## Fix 3 — web-frontend: Make the Preference Meaningful

Label `node01` with `tier=frontend` so the preferred affinity can actually be honored:

```bash
kubectl label node node01 tier=frontend
```{{exec}}

The existing `web-frontend` pod won't move — `IgnoredDuringExecution` means running pods are never evicted when a better node appears. Delete the pod to force rescheduling on the now-labeled node:

```bash
kubectl delete pod -l app=web-frontend
```{{exec}}

The Deployment controller immediately creates a replacement. Check where it lands:

```bash
kubectl get pod -l app=web-frontend -o wide
```{{exec}}

It should now land on `node01`, which has `tier=frontend` and satisfies the preference.

## Challenge: Build a Combined Required + Preferred Affinity

Real workloads often use both types together: a hard constraint for correctness (must run in this zone) plus a soft hint for performance (prefer a node with an SSD).

First, add an `ssd=true` label to `node01` to simulate a high-performance node:

```bash
kubectl label node node01 ssd=true
```{{exec}}

Now deploy a `data-api` that **requires** `zone=us-east-1a` AND **prefers** `ssd=true`:

```bash
cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: data-api
  namespace: default
spec:
  replicas: 2
  selector:
    matchLabels:
      app: data-api
  template:
    metadata:
      labels:
        app: data-api
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
          preferredDuringSchedulingIgnoredDuringExecution:
          - weight: 80
            preference:
              matchExpressions:
              - key: ssd
                operator: In
                values:
                - "true"
      containers:
      - name: api
        image: nginx:1.25
EOF
```{{exec}}

Check pod placement:

```bash
kubectl get pods -l app=data-api -o wide
```{{exec}}

Both pods land on `node01` — it satisfies the required zone constraint AND the preferred SSD hint. Verify the node has both labels:

```bash
kubectl get node node01 --show-labels | tr ',' '\n' | grep -E 'zone|ssd|tier|accelerator'
```{{exec}}

## Final Verification

Confirm all four Deployments are fully available:

```bash
kubectl get deployments
```{{exec}}

Expected state:

```text
NAME           READY   UP-TO-DATE   AVAILABLE
cache-server   1/1     1            1
data-api       2/2     2            2
gpu-worker     2/2     2            2
web-frontend   1/1     1            1
```

Review where all pods landed to confirm affinity rules are being honored:

```bash
kubectl get pods -o wide
```{{exec}}

Every pod should be on `node01` — the only node that satisfies each Deployment's affinity constraints.
