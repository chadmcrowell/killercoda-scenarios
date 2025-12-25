## Step 13: Debug with network tools

```bash
kubectl debug minimal-app -it --image=nicolaka/netshoot --target=app
```{{exec}}

Inside netshoot:
- DNS: `nslookup kubernetes.default`, `dig kubernetes.default.svc.cluster.local`
- Connectivity: `ping -c 3 8.8.8.8`, `traceroute google.com`
- Ports: `nc -zv localhost 1-1000`
- HTTP: `curl -v http://kubernetes.default.svc`
