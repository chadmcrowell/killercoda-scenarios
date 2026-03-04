# Step 1 — Investigate the Problem

Before deploying the broken resources, understand how a Kubernetes Service actually routes traffic — because that model is exactly what you'll use to find the failures.

## How Kubernetes Services Route Traffic

A Service is not a container or a proxy. It's a **virtual IP** backed by iptables/IPVS rules that kube-proxy writes on every node. Traffic sent to a Service ClusterIP is intercepted by the kernel and forwarded to one of the pod IPs in the **Endpoints** object.

The Endpoints object is the bridge between a Service and its pods:

```text
Service (selector: app=checkout)
    │
    ▼
Endpoints (IPs of matched pods)
    │
    ▼
Pod (label: app=checkout, IP: 10.244.x.x)
```

The Endpoints list is built by the **Endpoints controller**, which:

1. Reads the Service's `selector` (every key=value pair)
2. Finds all pods in the same namespace where **all** labels match
3. Adds those pods' IPs + the Service's `targetPort` to the Endpoints list
4. kube-proxy reads the Endpoints and programs routing into the node's kernel

**If no pods match → Endpoints is empty → all traffic is silently dropped.**
**If the `targetPort` is wrong → Endpoints has IPs, but the connection is refused by the pod.**

## Deploy the Three Broken Applications

**`checkout` Deployment and Service** — the label that was renamed but the Service was not updated:

```bash
cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: checkout
  namespace: default
spec:
  replicas: 2
  selector:
    matchLabels:
      app: checkout-api
  template:
    metadata:
      labels:
        app: checkout-api
        tier: frontend
    spec:
      containers:
      - name: checkout
        image: nginx:1.25
        ports:
        - containerPort: 80
---
apiVersion: v1
kind: Service
metadata:
  name: checkout-svc
  namespace: default
spec:
  selector:
    app: checkout
  ports:
  - port: 80
    targetPort: 80
EOF
```{{exec}}

**`inventory` Deployment and Service** — the port that was misconfigured:

```bash
cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: inventory
  namespace: default
spec:
  replicas: 2
  selector:
    matchLabels:
      app: inventory
  template:
    metadata:
      labels:
        app: inventory
        tier: backend
    spec:
      containers:
      - name: inventory
        image: nginx:1.25
        ports:
        - containerPort: 80
---
apiVersion: v1
kind: Service
metadata:
  name: inventory-svc
  namespace: default
spec:
  selector:
    app: inventory
  ports:
  - port: 8080
    targetPort: 8081
EOF
```{{exec}}

**`payments` Deployment and Service** — the multi-label selector that partially matches:

```bash
cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: payments
  namespace: default
spec:
  replicas: 1
  selector:
    matchLabels:
      app: payments
      version: v1
  template:
    metadata:
      labels:
        app: payments
        version: v1
        tier: backend
    spec:
      containers:
      - name: payments
        image: nginx:1.25
        ports:
        - containerPort: 80
---
apiVersion: v1
kind: Service
metadata:
  name: payments-svc
  namespace: default
spec:
  selector:
    app: payments
    version: v2
  ports:
  - port: 80
    targetPort: 80
EOF
```{{exec}}

## Observe the Symptoms

Check that all pods are healthy:

```bash
kubectl get pods -o wide
```{{exec}}

Every pod is `Running` and `Ready`. From a pod perspective, nothing is wrong.

Now check the **Endpoints** — this is the first command to run when a Service isn't routing:

```bash
kubectl get endpoints
```{{exec}}

```text
NAME            ENDPOINTS         AGE
checkout-svc    <none>            ...
inventory-svc   <none>            ...
payments-svc    <none>            ...
```

All three services have empty endpoints. No pod IPs. No traffic will reach any of them.

Prove it by spinning up a test pod and attempting to reach each service:

```bash
kubectl run test --image=busybox:1.35 --rm -it --restart=Never -- \
  sh -c 'wget -qO- --timeout=3 http://checkout-svc 2>&1; echo "---"; wget -qO- --timeout=3 http://inventory-svc:8080 2>&1; echo "---"; wget -qO- --timeout=3 http://payments-svc 2>&1'
```{{exec}}

All three connections time out or fail. Pods are running, services exist — yet nothing works.
