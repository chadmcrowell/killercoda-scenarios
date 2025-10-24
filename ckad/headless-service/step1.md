Create a headless service to discover the individual pod IP addresses of a Stateful workload.

## What to do
- Create a namespace `stateful-demo`.
- Deploy a StatefulSet named `web` with three replicas using the `nginx:1.25` image and a ServiceAccount named `web-sa`.
- Expose the StatefulSet with a headless Service `web` (`clusterIP: None`) in the same namespace.
- Spin up a diagnostics pod `dns-client` (busybox) in `stateful-demo`.
- Use the diagnostics pod to resolve `web.stateful-demo.svc.cluster.local` and list the pod IP addresses returned.

<details><summary>Solution</summary>
<br>

```bash
kubectl create namespace stateful-demo
```{{exec}}

```bash
kubectl create serviceaccount web-sa -n stateful-demo
```{{exec}}

```bash
cat <<'STATEFUL' | kubectl apply -f -
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: web
  namespace: stateful-demo
spec:
  serviceName: web
  replicas: 3
  selector:
    matchLabels:
      app: web
  template:
    metadata:
      labels:
        app: web
    spec:
      serviceAccountName: web-sa
      containers:
      - name: nginx
        image: nginx:1.25
        ports:
        - containerPort: 80
STATEFUL
```{{exec}}

```bash
cat <<'SERVICE' | kubectl apply -f -
apiVersion: v1
kind: Service
metadata:
  name: web
  namespace: stateful-demo
spec:
  clusterIP: None
  selector:
    app: web
  ports:
  - port: 80
    targetPort: 80
SERVICE
```{{exec}}

```bash
kubectl -n stateful-demo run dns-client --image=busybox:1.36 --restart=Never --command -- sh -c "sleep 3600"
```{{exec}}

```bash
kubectl -n stateful-demo exec dns-client -- nslookup web.stateful-demo.svc.cluster.local
```{{exec}}

</details>
