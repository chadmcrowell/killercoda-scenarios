# Step 3 — Apply the Fix

Fix each DaemonSet and confirm every expected node gets a running pod.

## Fix 1 — node-exporter: Label the Nodes

The `node-exporter` DaemonSet is waiting for nodes labeled `node-monitoring=enabled`. Label both nodes to make them eligible:

```bash
kubectl label node controlplane node-monitoring=enabled
kubectl label node node01 node-monitoring=enabled
```{{exec}}

Verify both nodes now match the nodeSelector:

```bash
kubectl get nodes -l node-monitoring=enabled
```{{exec}}

Both nodes should appear. The DaemonSet controller reconciles continuously — now that eligible nodes exist, it will create pods automatically. Check the DaemonSet:

```bash
kubectl get daemonset node-exporter
```{{exec}}

DESIRED should now be 2. Watch the pods come up:

```bash
kubectl get pods -l app=node-exporter -o wide -w
```{{exec}}

Press `Ctrl+C` once both pods show `Running`. The `node-exporter` already had tolerations for both node taints, so no toleration changes were needed — just the missing labels.

## Fix 2 — log-collector: Add the Missing Tolerations

The `log-collector` needs tolerations for both `NoSchedule` taints. Delete the broken DaemonSet and recreate it with the correct tolerations:

```bash
kubectl delete daemonset log-collector
```{{exec}}

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
      tolerations:
      - key: "node-role.kubernetes.io/control-plane"
        operator: "Exists"
        effect: "NoSchedule"
      - key: "dedicated"
        operator: "Equal"
        value: "logging"
        effect: "NoSchedule"
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

Watch the pods start:

```bash
kubectl get pods -l app=log-collector -o wide -w
```{{exec}}

Press `Ctrl+C` once both pods are `Running`. You should see one pod on `controlplane` and one on `node01`.

## Final Verification

Confirm both DaemonSets are fully healthy:

```bash
kubectl get daemonsets
```{{exec}}

Expected state:

```text
NAME            DESIRED   CURRENT   READY   UP-TO-DATE   AVAILABLE   NODE SELECTOR
log-collector   2         2         2       2            2           <none>
node-exporter   2         2         2       2            2           node-monitoring=enabled
```

Confirm pod placement — one pod per DaemonSet per node:

```bash
kubectl get pods -o wide
```{{exec}}

You should see 4 pods total: 2 for `node-exporter` and 2 for `log-collector`, each pair with one pod on `controlplane` and one on `node01`.

Check pod logs to confirm both are running normally:

```bash
kubectl logs -l app=log-collector --tail=5
```{{exec}}
