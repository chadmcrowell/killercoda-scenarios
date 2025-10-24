Create two Ingress rules for `/` where one sends 90% traffic to `web` and 10% to `web-v2` using annotations.

<details><summary>Solution</summary>
<br>

```bash
# Solution commands for canary-ingress
cat <<'EOF' | kubectl apply -f -
apiVersion: v1
kind: Namespace
metadata:
  name: canary-ingress
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: web
  namespace: canary-ingress
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
      - name: echo
        image: hashicorp/http-echo:0.2.3
        args:
        - "-text=web"
        ports:
        - containerPort: 5678
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: web-v2
  namespace: canary-ingress
spec:
  replicas: 1
  selector:
    matchLabels:
      app: web-v2
  template:
    metadata:
      labels:
        app: web-v2
    spec:
      containers:
      - name: echo
        image: hashicorp/http-echo:0.2.3
        args:
        - "-text=web-v2"
        ports:
        - containerPort: 5678
---
apiVersion: v1
kind: Service
metadata:
  name: web
  namespace: canary-ingress
spec:
  selector:
    app: web
  ports:
  - port: 80
    targetPort: 5678
---
apiVersion: v1
kind: Service
metadata:
  name: web-v2
  namespace: canary-ingress
spec:
  selector:
    app: web-v2
  ports:
  - port: 80
    targetPort: 5678
EOF
```{{exec}}

```bash
# primary ingress sending 100% of traffic to web
cat <<'EOF' | kubectl apply -f -
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: web
  namespace: canary-ingress
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
spec:
  ingressClassName: nginx
  rules:
  - host: canary.local
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: web
            port:
              number: 80
EOF
```{{exec}}

```bash
# canary ingress sending 10% of traffic to web-v2
cat <<'EOF' | kubectl apply -f -
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: web-canary
  namespace: canary-ingress
  annotations:
    nginx.ingress.kubernetes.io/canary: "true"
    nginx.ingress.kubernetes.io/canary-weight: "10"
spec:
  ingressClassName: nginx
  rules:
  - host: canary.local
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: web-v2
            port:
              number: 80
EOF
```{{exec}}

```bash
# busybox client to probe ingress responses
kubectl -n canary-ingress run curl --image=busybox:1.36 --restart=Never --command -- sh -c "while true; do wget -qO- http://canary.local && sleep 1; done"
```{{exec}}

```bash
# stream several responses to observe ~90/10 split
kubectl -n canary-ingress logs -f curl
```{{exec}}

</details>
