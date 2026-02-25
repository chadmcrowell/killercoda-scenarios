## Step 1: Check for Ingress controller

```bash
kubectl get pods -A | grep ingress
```{{exec}}

```bash
kubectl get ingressclass
```{{exec}}

An Ingress resource is just configuration — it does nothing without a controller to implement it. The IngressClass tells Kubernetes which controller should process each Ingress object.

Common Ingress controllers:
- nginx-ingress-controller
- traefik
- haproxy-ingress
- AWS ALB Ingress Controller
- GCE Ingress Controller
