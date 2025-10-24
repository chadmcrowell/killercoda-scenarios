Create an Ingress with TLS enabled using a secret named `tls-secret`.

1. Create a namespace named `ingress-tls`
2. Create a secret that contains a new SSL certificate, including the `tls.crt` and `tls.key`.
3. Create a deployment named `web` that uses the image `nginx:1.25` and exposes the container on port `80`.
4. Create a service from the deployment, also called `web`, and also exposed on port `80`.
5. Including the TLS secret, create an ingress resource named `web-ingress` that directs `tls.example.com` to the `web` service.
6. Curl `tls.example.com` and get a `200` response.

<details><summary>Solution</summary>
<br>

```bash
kubectl create namespace ingress-tls
```{{exec}}

```bash
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout tls.key -out tls.crt \
  -subj "/CN=tls.example.com/O=Example Org"
```{{exec}}

```bash
kubectl -n ingress-tls create secret tls tls-secret --cert=tls.crt --key=tls.key
```{{exec}}

```bash
kubectl -n ingress-tls create deploy web --image=nginx:1.25 --port=80
```{{exec}}

```bash
kubectl -n ingress-tls expose deploy web --port=80 --target-port=80
```{{exec}}

```bash
cat <<'EOF2' | kubectl apply -f -
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: web-ingress
  namespace: ingress-tls
spec:
  ingressClassName: nginx
  tls:
  - hosts:
    - tls.example.com
    secretName: tls-secret
  rules:
  - host: tls.example.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: web
            port:
              number: 80
EOF2
```{{exec}}

```bash
kubectl -n ingress-tls get ingress web-ingress -o yaml | sed -n '1,40p'
```{{exec}}

```bash
# just the INTERNAL-IP column for quick reference
NODE_IP=$(kubectl get nodes -o jsonpath='{range .items[*]}{.status.addresses[?(@.type=="InternalIP")].address}{"\n"}{end}')
```{{exec}}

```bash
curl -kI -H 'Host: tls.example.com' https://$NODE_IP:30443/
```{{exec}}

</details>
