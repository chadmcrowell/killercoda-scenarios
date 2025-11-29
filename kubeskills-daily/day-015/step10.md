## Step 10: Debugging Ingress routing

```bash
NGINX_POD=$(kubectl get pods -n ingress-nginx -l app.kubernetes.io/component=controller -o jsonpath='{.items[0].metadata.name}')

kubectl exec -n ingress-nginx $NGINX_POD -- cat /etc/nginx/nginx.conf | grep -A 20 "server_name api.example.com"
```{{exec}}

```bash
NGINX_POD=$(kubectl get pods -n ingress-nginx -l app.kubernetes.io/component=controller -o jsonpath='{.items[0].metadata.name}')

kubectl logs -n ingress-nginx $NGINX_POD --tail=50
```{{exec}}

Inspect generated nginx config and controller logs to see how routes were compiled.
