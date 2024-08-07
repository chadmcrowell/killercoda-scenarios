View the PVCs that were created along with the statefulSet pods.

The `volumeMounts` field in the StatefulSet spec ensures that the `/usr/share/nginx/html` directory is backed by a PersistentVolume.

Write the Pods' hostnames to their `index.html` files and verify that the NGINX webservers serve the hostnames

<br>
<details><summary>Solution</summary>
<br>

```bash
kubectl get pvc -l app=nginx
```{{exec}}

```bash
for i in 0 1; do kubectl exec "web-$i" -- sh -c 'echo "$(hostname)" > /usr/share/nginx/html/index.html'; done
```{{exec}}


</details>