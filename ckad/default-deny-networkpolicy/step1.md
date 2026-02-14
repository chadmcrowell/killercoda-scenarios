Lock down the `payments` namespace so that pods accept no inbound or outbound traffic unless another policy explicitly allows it.

## What to do
- Create a namespace named `payments` and deploy the following workloads inside it:
  - Deployment `api` running the `nginx:1.25` image with label `app=api` and exposed on port 80 via a `ClusterIP` service also named `api`.
  - Deployment `worker` running `busybox:1.36` with label `app=worker`; keep the containers running with `sleep 3600`.
- Launch a temporary BusyBox pod named `tester` in the `payments` namespace for connectivity checks.
- Write a NetworkPolicy named `default-deny` in the `payments` namespace that:
  - Applies to all pods (`podSelector: {}`);
  - Sets both `Ingress` and `Egress` policy types;
  - Provides empty ingress and egress rule lists to deny all traffic by default.
- Show that the `tester` pod fails to `wget http://api` and that `kubectl -n payments exec deploy/api -c nginx -- wget -qO- http://example.com` is blocked.

<details><summary>Solution</summary>
<br>

```bash
# namespace and workloads
cat <<'EOF' | kubectl apply -f -
apiVersion: v1
kind: Namespace
metadata:
  name: payments
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: api
  namespace: payments
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
  namespace: payments
spec:
  selector:
    app: api
  ports:
  - port: 80
    targetPort: 80
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: worker
  namespace: payments
spec:
  replicas: 1
  selector:
    matchLabels:
      app: worker
  template:
    metadata:
      labels:
        app: worker
    spec:
      containers:
      - name: busybox
        image: busybox:1.36
        command:
        - sh
        - -c
        - sleep 3600
EOF
```{{exec}}

```bash
# tester pod for validation
kubectl -n payments run tester --image=busybox:1.36 --restart=Never --command -- sh -c "sleep 3600"
```{{exec}}

```bash
# default deny policy
cat <<'EOF' | kubectl apply -f -
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: default-deny
  namespace: payments
spec:
  podSelector: {}
  policyTypes:
  - Ingress
  - Egress
  ingress: []
  egress: []
EOF
```{{exec}}

```bash
# verify ingress to api is blocked
kubectl -n payments exec tester -- wget -qO- http://api
```{{exec}}

```bash
# verify egress from api pods is blocked
kubectl -n payments exec deploy/api -c nginx -- wget -qO- http://example.com
```{{exec}}

</details>
