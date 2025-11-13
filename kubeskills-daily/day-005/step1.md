## Step 1: Deploy pods on every node

```bash
kubectl create deployment nginx --image=nginx --replicas=3
```{{exec}}

```bash
kubectl get pods -o wide
```{{exec}}

Note which node each replica landed on.
