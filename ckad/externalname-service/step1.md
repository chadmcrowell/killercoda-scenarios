Expose an external hostname through Kubernetes without creating endpoints.

## What to do
- Create a namespace named `externalname-demo`.
- Define a Service named `external-search` in that namespace with `type: ExternalName` pointing to `www.google.com`.
- Start a BusyBox pod called `dns-tool` in the same namespace that sleeps so you can exec into it.
- From the `dns-tool` pod, resolve `external-search.externalname-demo.svc.cluster.local` and confirm it returns `www.google.com`.

<details><summary>Solution</summary>
<br>

```bash
kubectl create namespace externalname-demo
```{{exec}}

```bash
cat <<'EOF' | kubectl apply -f -
apiVersion: v1
kind: Service
metadata:
  name: external-search
  namespace: externalname-demo
spec:
  type: ExternalName
  externalName: www.google.com
EOF
```{{exec}}

```bash
kubectl -n externalname-demo run dns-tool --image=busybox:1.36 --restart=Never --command -- sh -c "sleep 3600"
```{{exec}}

```bash
kubectl -n externalname-demo exec dns-tool -- nslookup external-search.externalname-demo.svc.cluster.local
```{{exec}}

</details>
