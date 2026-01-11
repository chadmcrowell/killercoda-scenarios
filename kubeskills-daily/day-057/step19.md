## Step 19: Test DaemonSet

```bash
# DaemonSets often need hostPath, hostNetwork
# Use baseline profile for system DaemonSets
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Namespace
metadata:
  name: system-ns
  labels:
    pod-security.kubernetes.io/enforce: baseline
    pod-security.kubernetes.io/warn: baseline
---
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: log-collector
  namespace: system-ns
spec:
  selector:
    matchLabels:
      app: logs
  template:
    metadata:
      labels:
        app: logs
    spec:
      containers:
      - name: collector
        image: busybox
        command: ['sh', '-c', 'tail -f /var/log/syslog']
        securityContext:
          allowPrivilegeEscalation: false
        volumeMounts:
        - name: logs
          mountPath: /var/log
          readOnly: true
      volumes:
      - name: logs
        hostPath:
          path: /var/log
          type: Directory
EOF

kubectl get daemonset log-collector -n system-ns
```{{exec}}

Baseline allows hostPath for system DaemonSets.
