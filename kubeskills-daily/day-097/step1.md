# Step 1 — Investigate the Problem

Set up the broken environment exactly as the analytics platform team left it, then trace the scheduling failure from the pods back to the affinity rules.

## Label the Worker Node and Create the Namespace

The infrastructure team tagged node01 to reflect the GPU hardware installed on it:

```bash
kubectl label node node01 accelerator=nvidia-t4
```{{exec}}

```bash
kubectl create namespace analytics
```{{exec}}

## Deploy the Batch Processing Service

The analytics team copied a deployment manifest from a different cluster that had V100 GPUs. The affinity rules were never updated for this environment:

```bash
cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: batch-processor
  namespace: analytics
spec:
  replicas: 3
  selector:
    matchLabels:
      app: batch-processor
  template:
    metadata:
      labels:
        app: batch-processor
    spec:
      affinity:
        nodeAffinity:
          requiredDuringSchedulingIgnoredDuringExecution:
            nodeSelectorTerms:
            - matchExpressions:
              - key: accelerator
                operator: In
                values:
                - nvidia-v100
      containers:
      - name: processor
        image: busybox:stable
        command: ["sh", "-c", "echo Processing batch job && sleep 3600"]
        resources:
          requests:
            cpu: "100m"
            memory: "128Mi"
EOF
```{{exec}}

## Observe the Failure

Check pod status:

```bash
kubectl get pods -n analytics
```{{exec}}

```text
NAME                               READY   STATUS    RESTARTS   AGE
batch-processor-7d9f8c6b5-4xkpq    0/1     Pending   0          15s
batch-processor-7d9f8c6b5-9lbzv    0/1     Pending   0          15s
batch-processor-7d9f8c6b5-mnpq2    0/1     Pending   0          15s
```

All three replicas are `Pending`. No containers have started. Describe one of the pods to read the scheduler's message:

```bash
kubectl describe pod -n analytics -l app=batch-processor | head -60
```{{exec}}

Scroll to the `Events` section:

```text
Events:
  Type     Reason            Age   From               Message
  ----     ------            ----  ----               -------
  Warning  FailedScheduling  12s   default-scheduler  0/2 nodes are available:
           1 node(s) had untolerated taint {node-role.kubernetes.io/control-plane: },
           1 node(s) didn't match Pod's node affinity/selector.
           preemption: 0/2 nodes are available: 2 Preemption is not helpful for scheduling.
```

Break down what the scheduler is reporting:

- `1 node(s) had untolerated taint {node-role.kubernetes.io/control-plane: }` — the controlplane node has a taint that rejects regular workloads, so it is ruled out immediately.
- `1 node(s) didn't match Pod's node affinity/selector` — node01 is available and taint-free, but its labels do not satisfy the affinity rules in the pod spec.

With both nodes disqualified, the scheduler has nowhere to place the pods. They will remain `Pending` indefinitely until either a matching node appears or the affinity rules are corrected.

Check the deployment itself to confirm no pods are ever ready:

```bash
kubectl get deployment batch-processor -n analytics
```{{exec}}

```text
NAME               READY   UP-TO-DATE   AVAILABLE   DESIRED
batch-processor    0/3     3            0           3
```

`READY 0/3` — zero replicas have ever reached a running state. The next step is to find the exact mismatch between what the affinity rules require and what the cluster actually has.
