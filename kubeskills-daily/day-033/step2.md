## Step 2: Verify Istio installation

```bash
kubectl get pods -n istio-system
kubectl get svc -n istio-system
```{{exec}}

Ensure control plane pods and services are running.
