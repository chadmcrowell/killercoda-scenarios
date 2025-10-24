Create an Ingress that rewrites `/app` to `/` for a service named `web`.

1. Create a namespace named `ingress-path-rewrite`
2. Create a deployment named `web` using the image `nginx:1.25` exposing the container on port `80`.
3. Expose the deployment, creating a ClusterIP type service named `web` also exposed on port `80`.
4. Create an ingress resource named `web-ingress` that rewrites `/app` to `/` and directs to the service `web`
5. Curl the ingress and get a `200` response. 

<details><summary>Solution</summary>
<br>

```bash
kubectl create namespace ingress-path-rewrite
```{{exec}}

```bash
kubectl -n ingress-path-rewrite create deploy web --image=nginx:1.25 --port=80
```{{exec}}

```bash
kubectl -n ingress-path-rewrite expose deploy web --port=80 --target-port=80
```{{exec}}

```bash
cat <<'EOF2' | kubectl apply -f -
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: web-ingress
  namespace: ingress-path-rewrite
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
spec:
  ingressClassName: nginx
  rules:
  - host: rewrite.example.com
    http:
      paths:
      - path: /app
        pathType: Prefix
        backend:
          service:
            name: web
            port:
              number: 80
EOF2
```{{exec}}

```bash
kubectl -n ingress-path-rewrite get ingress web-ingress
```{{exec}}

```bash
# just the INTERNAL-IP column for quick reference
NODE_IP=$(kubectl get nodes -o jsonpath='{range .items[*]}{.status.addresses[?(@.type=="InternalIP")].address}{"\n"}{end}')
```{{exec}}

```bash
curl -I -H 'Host: rewrite.example.com' http://$NODE_IP:30000/app
```{{exec}}

</details>
