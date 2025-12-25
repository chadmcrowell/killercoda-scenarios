## Step 1: Verify metrics-server is installed

```bash
kubectl get deployment metrics-server -n kube-system

kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml

kubectl patch deployment metrics-server -n kube-system --type='json' \
  -p='[{"op": "add", "path": "/spec/template/spec/containers/0/args/-", "value": "--kubelet-insecure-tls"}]'

kubectl wait --for=condition=Ready pods -l k8s-app=metrics-server -n kube-system --timeout=120s
```{{exec}}|skip{{sandbox}}

Install/patch metrics-server and wait for it to be ready.
