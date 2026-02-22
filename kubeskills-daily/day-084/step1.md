## Step 1: Check for Ingress controller

```bash
kubectl get pods -A | grep ingress
```{{exec}}

```bash
kubectl get ingressclass

echo ""
echo "Common Ingress controllers:"
echo "- nginx-ingress-controller"
echo "- traefik"
echo "- haproxy-ingress"
echo "- AWS ALB Ingress Controller"
echo "- GCE Ingress Controller"
```{{exec}}

An Ingress resource is just configuration — it does nothing without a controller to implement it. The IngressClass tells Kubernetes which controller should process each Ingress object.
