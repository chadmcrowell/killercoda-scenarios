# Step 4: Rollback and Troubleshoot
In this final step, you'll practice rollback operations and troubleshooting techniques.

First, let's create a problematic configuration by upgrading with invalid settings:
```bash
helm upgrade my-nginx-ingress nginx-stable/nginx-ingress \
  --namespace nginx-ingress \
  --set controller.image.tag="invalid-tag" \
  --set controller.replicaCount=5
```{{exec}}

Check the pod status - you should see some issues:
```bash
kubectl get pods -n nginx-ingress -w
```{{exec}}

Press `Ctrl+C` to stop watching after observing the failing pods.

View the release history to see all revisions:
```bash
helm history my-nginx-ingress -n nginx-ingress
```{{exec}}

Rollback to the previous working revision (revision 3):
```bash
helm rollback my-nginx-ingress 3 -n nginx-ingress
```{{exec}}

Check that the rollback was successful:
```bash
helm status my-nginx-ingress -n nginx-ingress
```{{exec}}

```bash
helm history my-nginx-ingress -n nginx-ingress
```{{exec}}

Verify pods are healthy again:
```bash
kubectl get pods -n nginx-ingress
```{{exec}}

Get values for the current release:
```bash
helm get values my-nginx-ingress -n nginx-ingress
```{{exec}}

Get all information about the release:
```bash
helm get all my-nginx-ingress -n nginx-ingress
```{{exec}}