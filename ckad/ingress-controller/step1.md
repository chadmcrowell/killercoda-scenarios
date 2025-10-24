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
kubectl -n ingress-nginx rollout status deploy/ingress-nginx-controller --timeout=180s
```{{exec}}

```bash
# list controller pods
kubectl -n ingress-nginx get pods -l app.kubernetes.io/component=controller
```{{exec}}

```bash
# inspect the service exposing the controller
kubectl -n ingress-nginx get svc ingress-nginx-controller
```{{exec}}

> Note: In the Killercoda environment the `EXTERNAL-IP` column displays `<pending>` permanently, because there is no external load balancer available. Use the NodePort listed in the service instead when you need to access the controller.

```bash
# change the service type to NodePort so it is reachable
kubectl -n ingress-nginx patch svc ingress-nginx-controller -p {spec:type:NodePort}
```{{exec}}

```bash
# confirm the NodePort that was allocated
kubectl -n ingress-nginx get svc ingress-nginx-controller -o wide
```{{exec}}

```bash
# retrieve the worker node IP and resulting URL
kubectl get nodes -o wide
```{{exec}}

```bash
# curl the controller (replace <node-ip> with the worker IP)
curl -I http://<node-ip>:30000
```{{exec}}


</details>
