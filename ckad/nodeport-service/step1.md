Expose an application externally using a NodePort service.

1. Launch a deployment named `web` running `nginx:1.25` with three replicas.
2. Expose the deployment with a NodePort service `web-nodeport` on node port `32080`.
3. Verify the external reachability using the node IP and NodePort.

<details><summary>Solution</summary>
<br>

```bash
kubectl create deploy web --image=nginx:1.25 --replicas=3
```{{exec}}

```bash
kubectl expose deploy web --port=80 --target-port=80 --type=NodePort --name=web-nodeport --overrides='{"spec":{"ports":[{"port":80,"targetPort":80,"nodePort":32080}]}}'
```{{exec}}

```bash
kubectl get svc web-nodeport
```{{exec}}

```bash
kubectl get nodes -o wide
```{{exec}}

```bash
# just the INTERNAL-IP column for quick reference
NODE_IP=$(kubectl get nodes -o jsonpath='{range .items[*]}{.status.addresses[?(@.type=="InternalIP")].address}{"\n"}{end}')
```{{exec}}

```bash
curl -I http://$NODE_IP:32080
```{{exec}}

</details>
