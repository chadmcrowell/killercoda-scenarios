Stop the `api` pods from making outbound connections to the internet while still letting them receive traffic.

## What to do
- Create a namespace `block-egress` and deploy an `nginx` application labelled `app=api`. Expose it with a `ClusterIP` service named `api`.
- Start a BusyBox pod named `bb-client` in the same namespace that will `sleep 3600` so you can test connectivity.
- Build a NetworkPolicy called `block-egress` in the `block-egress` namespace that:
  - Targets pods labelled `app=api`;
  - Allows ingress on TCP port 80 from any pod;
  - Denies all egress traffic (no egress rules);
  - Ensures the pods still accept incoming traffic but cannot `wget` external endpoints such as `http://example.com`.
- Validate that `kubectl -n block-egress exec bb-client -- wget -qO- http://api` works, but `kubectl -n block-egress exec deploy/api -c nginx -- wget -qO- http://example.com` fails or times out.

<details><summary>Solution</summary>
<br>

```bash
# namespace, deployment, and service
cat <<'EOF' | kubectl apply -f -
apiVersion: v1
kind: Namespace
metadata:
  name: block-egress
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: api
  namespace: block-egress
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
  namespace: block-egress
spec:
  selector:
    app: api
  ports:
  - port: 80
    targetPort: 80
EOF
```{{exec}}

```bash
# client pod for testing ingress
kubectl -n block-egress run bb-client --image=busybox:1.36 --restart=Never --command -- sh -c "sleep 3600"
```{{exec}}

```bash
# network policy denying all egress while permitting ingress on port 80
cat <<'EOF' | kubectl apply -f -
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: block-egress
  namespace: block-egress
spec:
  podSelector:
    matchLabels:
      app: api
  policyTypes:
  - Ingress
  - Egress
  ingress:
  - from:
    - podSelector: {}
    ports:
    - protocol: TCP
      port: 80
  egress: []
EOF
```{{exec}}

```bash
# verify ingress still works (returns HTML)
kubectl -n block-egress exec bb-client -- wget -qO- http://api
```{{exec}}

```bash
# verify egress is blocked (should fail)
kubectl -n block-egress exec deploy/api -c nginx -- wget -qO- http://example.com
```{{exec}}

</details>
