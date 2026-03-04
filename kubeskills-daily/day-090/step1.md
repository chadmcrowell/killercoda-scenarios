# Step 1 — Investigate the Problem

Before diving into the broken pod, take a moment to understand what multi-container pods are and why sidecars fail the way they do.

## Background: Multi-Container Pods

A Kubernetes pod can run more than one container. All containers in a pod:

- Share the same **network namespace** (same IP, same `localhost`)
- Can share **volumes** declared in the pod spec
- Have **independent lifecycles** — but if any container crashes, the pod restarts

The most common multi-container patterns are:

| Pattern     | Purpose                                                   |
|-------------|-----------------------------------------------------------|
| Sidecar     | Augments the main container (log forwarding, metrics)     |
| Ambassador  | Proxies network traffic on behalf of the main container   |
| Adapter     | Transforms the main container's output format             |

A crashing sidecar is one of the most confusing failures in Kubernetes because the main container is healthy — but the pod keeps restarting anyway.

## Deploy the Broken Pod

Deploy the `web-app` Deployment. It has two containers: an `app` container (nginx) and a `log-forwarder` sidecar that ships logs to a central collector:

```bash
cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: web-app
  namespace: default
spec:
  replicas: 1
  selector:
    matchLabels:
      app: web-app
  template:
    metadata:
      labels:
        app: web-app
    spec:
      containers:
      - name: app
        image: nginx:1.25
        volumeMounts:
        - name: shared-logs
          mountPath: /var/log/nginx
      - name: log-forwarder
        image: busybox:1.35
        command:
        - sh
        - -c
        - |
          echo "Starting log forwarder..."
          tail -f /var/log/app/access.log
      volumes:
      - name: shared-logs
        emptyDir: {}
EOF
```{{exec}}

## Observe the Restart Loop

Wait a few seconds and check pod status:

```bash
kubectl get pods -l app=web-app
```{{exec}}

The pod will cycle through `Running` → `Error` → `CrashLoopBackOff`. Watch it happen in real time:

```bash
kubectl get pods -l app=web-app -w
```{{exec}}

Press `Ctrl+C` after you see the restart count increment at least once. Note the `RESTARTS` column climbing.

Check both containers' statuses side by side:

```bash
kubectl get pod -l app=web-app \
  -o jsonpath='{range .items[0].status.containerStatuses[*]}{.name}: ready={.ready}, restarts={.restartCount}, state={.state}{"\n"}{end}'
```{{exec}}

One container shows `ready=true`. The other is in a crash state. The pod keeps restarting because of the unhealthy sidecar.

Look at the cluster events for the pod:

```bash
kubectl get events --sort-by=.lastTimestamp --field-selector reason=BackOff
```{{exec}}

Kubernetes is applying exponential backoff between restart attempts — each time the sidecar crashes, the wait before the next restart doubles (10s → 20s → 40s → up to 5 minutes).
