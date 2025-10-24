Lock down ingress so that the `api` service only accepts traffic on TCP port 80.

## What to do
- Create a namespace called `allow-port` and deploy an `nginx` workload labelled `app=api`. Expose it through a `ClusterIP` service named `api` that targets port 80.
- Spin up two BusyBox pods in the same namespace for testing: `bb-http` (for port 80) and `bb-ssh` (for port 22). Keep them running with a long `sleep`.
- Write a NetworkPolicy named `allow-only-port` in the `allow-port` namespace that:
  - Selects pods with label `app=api`;
  - Allows ingress only from any pod on TCP port 80;
  - Denies other ingress traffic.
- Validate that `bb-http` can reach `http://api` with `wget -qO- http://api`, while `bb-ssh` fails when trying `nc -z api 22`.

<details><summary>Solution</summary>
<br>

```bash
# namespace, deployment, and service
cat <<'EOF' | kubectl apply -f -
apiVersion: v1
kind: Namespace
metadata:
  name: allow-port
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: api
  namespace: allow-port
spec:
  replicas: 2
  selector:
    matchLabels:
      app: api
  template:
    metadata:
      labels:
        app: api
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
  name: api
  namespace: allow-port
spec:
  selector:
    app: api
  ports:
  - name: http
    port: 80
    targetPort: 80
EOF
```{{exec}}

```bash
# test pods
kubectl -n allow-port run bb-http --image=busybox:1.36 --restart=Never --command -- sh -c "sleep 3600"
```{{exec}}

```bash
kubectl -n allow-port run bb-ssh --image=busybox:1.36 --restart=Never --command -- sh -c "sleep 3600"
```{{exec}}

```bash
# network policy allowing only TCP 80
cat <<'EOF' | kubectl apply -f -
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-only-port
  namespace: allow-port
spec:
  podSelector:
    matchLabels:
      app: api
  policyTypes:
  - Ingress
  ingress:
  - ports:
    - protocol: TCP
      port: 80
    from:
    - podSelector: {}
EOF
```{{exec}}

```bash
# confirm http (port 80) is allowed; expect HTML
kubectl -n allow-port exec bb-http -- wget -qO- http://api
```{{exec}}

```bash
# confirm other ports (22) are blocked; expect timeout or failure
kubectl -n allow-port exec bb-ssh -- nc -z api 22
```{{exec}}

</details>
