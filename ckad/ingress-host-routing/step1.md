Create a namespace named `ingress-host-routing`. 

Create a deployment named `web` with the image `nginx:1.25` exposing port 80 from the container.

Expose the deployment, creating a ClusterIP type service, also on port `80`.

Create an Ingress named `web-ingress` that routes `web.example.com` to a service named `web`.

Check if ingress returns a 200 response.

<details><summary>Solution</summary>
<br>

```bash
kubectl create namespace ingress-host-routing
```{{exec}}

```bash
kubectl -n ingress-host-routing create deploy web --image=nginx:1.25 --port=80
```{{exec}}

```bash
kubectl -n ingress-host-routing expose deploy web --port=80 --target-port=80
```{{exec}}

```bash
cat <<'EOF' | kubectl apply -f -
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: web-ingress
  namespace: ingress-host-routing
spec:
  ingressClassName: nginx
  rules:
  - host: web.example.com
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
kubectl -n ingress-host-routing get ingress web-ingress
```{{exec}}

```bash
# just the INTERNAL-IP column for quick reference
NODE_IP=$(kubectl get nodes -o jsonpath='{range .items[*]}{.status.addresses[?(@.type=="InternalIP")].address}{"\n"}{end}')
```{{exec}}

```bash
curl -I -H 'Host: web.example.com' http://$NODE_IP:30000/
```{{exec}}

</details>
