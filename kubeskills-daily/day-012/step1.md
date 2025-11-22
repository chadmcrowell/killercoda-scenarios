## Prerequisite: Verify metrics-server

```bash
kubectl top nodes
```{{exec}}

If metrics-server is missing, install and allow insecure TLS to the kubelet:

```bash
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
kubectl patch deployment metrics-server -n kube-system --type='json' -p='[{"op": "add", "path": "/spec/template/spec/containers/0/args/-", "value": "--kubelet-insecure-tls"}]'
```{{exec}}

Wait about 60 seconds for metrics to populate, then continue.
