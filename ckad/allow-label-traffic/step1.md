Enforce that only pods with an `access=granted` label can reach the `web` workload.

## What to do
- Create a namespace named `allow-label` and deploy an `nginx` application exposed through a `ClusterIP` service called `web`.
- Start two BusyBox pods in the same namespace for testing: one labelled `access=granted` (`bb-allowed`) and another without that label (`bb-denied`). Keep them running with a long `sleep`.
- Write a NetworkPolicy named `allow-label-traffic` in the `allow-label` namespace that:
  - Selects the `web` pods (`app=web`);
  - Allows ingress only on TCP port 80;
  - Permits traffic exclusively from pods labelled `access=granted`.
- Verify that `bb-allowed` can successfully `wget -qO- http://web` while `bb-denied` cannot.

<details><summary>Solution</summary>
<br>

```bash
# create namespace, deployment, and service
cat <<'EOF' | kubectl apply -f -
apiVersion: v1
kind: Namespace
metadata:
  name: allow-label
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: web
  namespace: allow-label
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
  namespace: allow-label
spec:
  selector:
    app: web
  ports:
  - port: 80
    targetPort: 80
EOF
```{{exec}}

```bash
# launch test pods
kubectl -n allow-label run bb-allowed --image=busybox:1.36 --labels=access=granted --restart=Never --command -- sh -c "sleep 3600"
```{{exec}}

```bash
kubectl -n allow-label run bb-denied --image=busybox:1.36 --restart=Never --command -- sh -c "sleep 3600"
```{{exec}}

```bash
# apply the network policy allowing only labelled pods to reach web on port 80
cat <<'EOF' | kubectl apply -f -
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-label-traffic
  namespace: allow-label
spec:
  podSelector:
    matchLabels:
      app: web
  policyTypes:
  - Ingress
  ingress:
  - from:
    - podSelector:
        matchLabels:
          access: granted
    ports:
    - protocol: TCP
      port: 80
EOF
```{{exec}}

```bash
# verify allowed traffic (should return HTML)
kubectl -n allow-label exec bb-allowed -- wget -qO- http://web
```{{exec}}

```bash
# verify denied traffic (command should time out or fail)
kubectl -n allow-label exec bb-denied -- wget -qO- http://web
```{{exec}}

</details>
