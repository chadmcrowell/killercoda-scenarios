# Step 1 — Investigate the Problem

The observability team's two DaemonSets aren't working. Deploy the broken resources and get a clear picture of what the cluster is reporting.

## Simulate the Infrastructure Taint

During a recent maintenance window, the ops team added a taint to `node01` to restrict which workloads can land there. This taint is still in place:

```bash
kubectl taint node node01 dedicated=logging:NoSchedule
```{{exec}}

Confirm the taint was applied:

```bash
kubectl describe node node01 | grep -A5 Taints
```{{exec}}

## Deploy the Broken DaemonSets

Deploy the `node-exporter` DaemonSet (Prometheus node metrics collector). This one already has tolerations in its spec, but something else is wrong:

```bash
cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: node-exporter
  namespace: default
spec:
  selector:
    matchLabels:
      app: node-exporter
  template:
    metadata:
      labels:
        app: node-exporter
    spec:
      tolerations:
      - key: "node-role.kubernetes.io/control-plane"
        operator: "Exists"
        effect: "NoSchedule"
      - key: "dedicated"
        operator: "Equal"
        value: "logging"
        effect: "NoSchedule"
      nodeSelector:
        node-monitoring: "enabled"
      hostNetwork: true
      containers:
      - name: node-exporter
        image: prom/node-exporter:v1.6.1
        ports:
        - containerPort: 9100
          hostPort: 9100
EOF
```{{exec}}

Now deploy the `log-collector` DaemonSet (log shipping agent):

```bash
cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: log-collector
  namespace: default
spec:
  selector:
    matchLabels:
      app: log-collector
  template:
    metadata:
      labels:
        app: log-collector
    spec:
      containers:
      - name: log-collector
        image: busybox:1.35
        command: ["sh", "-c", "tail -f /var/log/syslog 2>/dev/null || sleep 3600"]
        volumeMounts:
        - name: varlog
          mountPath: /var/log
          readOnly: true
      volumes:
      - name: varlog
        hostPath:
          path: /var/log
EOF
```{{exec}}

## Observe the Cluster State

Check the DaemonSet summary:

```bash
kubectl get daemonsets
```{{exec}}

You should see two completely different failure signatures:

```text
NAME            DESIRED   CURRENT   READY   UP-TO-DATE   AVAILABLE   NODE SELECTOR
log-collector   2         2         0       2            0           <none>
node-exporter   0         0         0       0            0           node-monitoring=enabled
```

`node-exporter` has DESIRED=0 — it's not even trying to create pods. `log-collector` has DESIRED=2 but READY=0 — it's trying but failing on every node.

Check pod placement across nodes:

```bash
kubectl get pods -o wide
```{{exec}}

`log-collector` pods exist but are stuck in `Pending`. `node-exporter` has no pods at all.

Look for scheduling error events:

```bash
kubectl get events --sort-by=.lastTimestamp --field-selector reason=FailedScheduling
```{{exec}}

The events only mention `log-collector`. `node-exporter` doesn't even appear here — it never tried to schedule anything.
