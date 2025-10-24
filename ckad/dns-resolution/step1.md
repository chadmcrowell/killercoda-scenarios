Demonstrate how core DNS features work inside the cluster by resolving service names from different namespaces.

## What to do
- In namespace `dns-lab`, create a `busybox:1.36` pod named `dns-client` that sleeps so you can run interactive commands.
- Deploy an `nginx:1.25` service named `web` in namespace `web` (create the namespace if needed) and expose it with a `ClusterIP` service on port 80.
- From the `dns-client` pod, resolve:
  - The short service name `web` (should only work with `web.dns-lab.svc.cluster.local` or when in the same namespace).
  - The fully qualified domain name `web.web.svc.cluster.local`.
  - The headless service DNS entry after converting the service to headless mode.
- Record the commands and resulting DNS lookups.

<details><summary>Solution</summary>
<br>

```bash
kubectl create namespace dns-lab
kubectl create namespace web
```{{exec}}

```bash
kubectl -n dns-lab run dns-client --image=busybox:1.36 --restart=Never --command -- sh -c "sleep 3600"
```{{exec}}

```bash
cat <<'EOF' | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: web
  namespace: web
spec:
  replicas: 2
  selector:
    matchLabels:
      app: web
  template:
    metadata:
      labels:
        app: web
    spec:
      containers:
      - name: nginx
        image: nginx:1.25
        ports:
        - containerPort: 80
---
apiVersion: v1
kind: Service
metadata:
  name: web
  namespace: web
spec:
  selector:
    app: web
  ports:
  - port: 80
    targetPort: 80
EOF
```{{exec}}

```bash
# short name (fails because namespaces differ)
kubectl -n dns-lab exec dns-client -- nslookup web
```{{exec}}

```bash
# FQDN succeeds
kubectl -n dns-lab exec dns-client -- nslookup web.web.svc.cluster.local
```{{exec}}

```bash
# convert to headless service and resolve pod endpoints
kubectl -n web delete service web
kubectl -n web expose deployment web --name=web --port=80 --cluster-ip=None
```{{exec}}

```bash
kubectl -n dns-lab exec dns-client -- nslookup web.web.svc.cluster.local
```{{exec}}

</details>
