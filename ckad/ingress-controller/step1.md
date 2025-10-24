Install the NGINX Ingress Controller using the official manifest and verify that the controller pod is running.

1. Install the community ingress-nginx controller.
2. Confirm the controller pod is running in `ingress-nginx`.
3. Inspect the created Service to see how traffic will reach the controller.

<details><summary>Solution</summary>
<br>

```bash
# apply the official manifest
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/cloud/deploy.yaml
```{{exec}}

```bash
# wait for the controller pod to be ready
kubectl -n ingress-nginx wait --for=condition=Available deploy/ingress-nginx-controller --timeout=180s
```{{exec}}

```bash
# list controller pods
kubectl -n ingress-nginx get pods -l app.kubernetes.io/component=controller
```{{exec}}

```bash
# inspect the service exposing the controller
kubectl -n ingress-nginx get svc ingress-nginx-controller
```{{exec}}

</details>
