Restrict access to the `web` service so that only pods from an approved namespace can connect.

## What to do
- Create a namespace named `allow-ns` and deploy an `nginx` application exposed via a `ClusterIP` service called `web`.
- Create two additional namespaces: `trusted` and `untrusted`. Label the `trusted` namespace with `access=granted`.
- Launch BusyBox pods for testing: `client-trusted` in the `trusted` namespace and `client-untrusted` in the `untrusted` namespace. Keep them running with a long `sleep`.
- Craft a NetworkPolicy named `allow-namespace-traffic` in the `allow-ns` namespace that:
  - Targets pods with `app=web`;
  - Allows ingress only on TCP port 80;
  - Permits traffic solely from namespaces labelled `access=granted`.
- Confirm that `client-trusted` can `wget -qO- http://web.allow-ns` while `client-untrusted` cannot reach the service.

<details><summary>Solution</summary>
<br>

```bash
# namespace, deployment, and service
cat <<'EOF' | kubectl apply -f -
apiVersion: v1
kind: Namespace
metadata:
  name: allow-ns
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: web
  namespace: allow-ns
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
  namespace: allow-ns
spec:
  selector:
    app: web
  ports:
  - port: 80
    targetPort: 80
EOF
```{{exec}}

```bash
# prepare namespaces and test pods
kubectl create namespace trusted
```{{exec}}

```bash
kubectl create namespace untrusted
```{{exec}}

```bash
kubectl label namespace trusted access=granted
```{{exec}}

```bash
kubectl -n trusted run client-trusted --image=busybox:1.36 --restart=Never --command -- sh -c "sleep 3600"
```{{exec}}

```bash
kubectl -n untrusted run client-untrusted --image=busybox:1.36 --restart=Never --command -- sh -c "sleep 3600"
```{{exec}}

```bash
# network policy allowing only the labelled namespace
cat <<'EOF' | kubectl apply -f -
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-namespace-traffic
  namespace: allow-ns
spec:
  podSelector:
    matchLabels:
      app: web
  policyTypes:
  - Ingress
  ingress:
  - from:
    - namespaceSelector:
        matchLabels:
          access: granted
    ports:
    - protocol: TCP
      port: 80
EOF
```{{exec}}

```bash
# verify trusted namespace traffic (returns HTML)
kubectl -n trusted exec client-trusted -- wget -qO- http://web.allow-ns
```{{exec}}

```bash
# verify other namespaces are blocked (fails or times out)
kubectl -n untrusted exec client-untrusted -- wget -qO- http://web.allow-ns
```{{exec}}

</details>
