# Step 3 — Apply the Fix

Fix all three issues in the sidecar, verify stability, then build a second multi-container pod from scratch to cement the pattern.

## Fix the Deployment

Delete and redeploy `web-app` with the corrected sidecar: right path, correct volume mount, and resource limits:

```bash
kubectl delete deployment web-app
```{{exec}}

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
        resources:
          requests:
            cpu: "100m"
            memory: "64Mi"
          limits:
            cpu: "200m"
            memory: "128Mi"
      - name: log-forwarder
        image: busybox:1.35
        command:
        - sh
        - -c
        - |
          echo "Log forwarder started. Waiting for access log..."
          until [ -f /var/log/nginx/access.log ]; do sleep 1; done
          echo "Tailing access log..."
          tail -f /var/log/nginx/access.log
        volumeMounts:
        - name: shared-logs
          mountPath: /var/log/nginx
          readOnly: true
        resources:
          requests:
            cpu: "50m"
            memory: "32Mi"
          limits:
            cpu: "100m"
            memory: "64Mi"
      volumes:
      - name: shared-logs
        emptyDir: {}
EOF
```{{exec}}

## Verify Stability

Watch the pod start up:

```bash
kubectl get pods -l app=web-app -w
```{{exec}}

Press `Ctrl+C` once both containers show `2/2 Running`. The restart count should stay at 0.

Confirm both containers are ready with zero restarts:

```bash
kubectl get pod -l app=web-app \
  -o jsonpath='{range .items[0].status.containerStatuses[*]}{.name}: ready={.ready}, restarts={.restartCount}{"\n"}{end}'
```{{exec}}

Check that the sidecar is running cleanly:

```bash
kubectl logs -l app=web-app -c log-forwarder
```{{exec}}

Output:

```text
Log forwarder started. Waiting for access log...
Tailing access log...
```

No errors. The sidecar found the shared volume, located the log file, and is now tailing it successfully.

## Build a Multi-Container Pod from Scratch

Now build a second example using the **content-writer** pattern: a sidecar that writes HTML content to a shared volume, and nginx that serves it. This demonstrates the full shared-volume workflow clearly.

```bash
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: content-pod
  namespace: default
spec:
  containers:
  - name: nginx
    image: nginx:1.25
    volumeMounts:
    - name: web-content
      mountPath: /usr/share/nginx/html
    ports:
    - containerPort: 80
  - name: content-writer
    image: busybox:1.35
    command:
    - sh
    - -c
    - |
      i=1
      while true; do
        echo "<h1>Version $i — written by the sidecar at $(date)</h1>" \
          > /content/index.html
        i=$((i + 1))
        sleep 5
      done
    volumeMounts:
    - name: web-content
      mountPath: /content
    resources:
      requests:
        cpu: "50m"
        memory: "32Mi"
      limits:
        cpu: "100m"
        memory: "64Mi"
  volumes:
  - name: web-content
    emptyDir: {}
EOF
```{{exec}}

Wait for both containers to start:

```bash
kubectl get pod content-pod
```{{exec}}

Check the sidecar is writing content:

```bash
kubectl logs content-pod -c content-writer
```{{exec}}

Exec into the nginx container and read the file the sidecar wrote:

```bash
kubectl exec content-pod -c nginx -- cat /usr/share/nginx/html/index.html
```{{exec}}

Wait 10 seconds and read it again to see the sidecar's updates:

```bash
sleep 10 && kubectl exec content-pod -c nginx -- cat /usr/share/nginx/html/index.html
```{{exec}}

The version number and timestamp will have changed — the sidecar and main container are sharing state correctly through the emptyDir volume.

## Key Observations

Check that both pods are stable and none are restarting:

```bash
kubectl get pods
```{{exec}}

Inspect the resource usage difference between the two containers in `web-app`:

```bash
kubectl get pod -l app=web-app \
  -o jsonpath='{range .items[0].spec.containers[*]}Container: {.name}{"\n"}  CPU: requests={.resources.requests.cpu}, limits={.resources.limits.cpu}{"\n"}  MEM: requests={.resources.requests.memory}, limits={.resources.limits.memory}{"\n"}{end}'
```{{exec}}

The sidecar is intentionally given lower limits than the main container — this prevents it from starving the application it supports.
