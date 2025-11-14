## Install Application Using Helm Chart
Now you'll install an nginx ingress controller using the Helm chart with specific requirements.

Create a namespace for the ingress controller:
```bash
kubectl create namespace nginx-ingress
```{{exec}}

Install the nginx-ingress chart with specific configurations:
```bash
helm install my-nginx-ingress nginx-stable/nginx-ingress \
  --namespace nginx-ingress \
  --set controller.replicaCount=2 \
  --set controller.service.type=NodePort \
  --set controller.service.httpPort.nodePort=30080 \
  --set controller.service.httpsPort.nodePort=30443
```{{exec}}

Check the Helm release status:
```bash
helm status my-nginx-ingress -n nginx-ingress
```{{exec}}

List all Helm releases:
```bash
helm list -A
```{{exec}}

Verify the pods are running:
```bash
kubectl get pods -n nginx-ingress
```{{exec}}

Check the service configuration:
```bash
kubectl get svc -n nginx-ingress
```{{exec}}

Get the release history:
```bash
helm history my-nginx-ingress -n nginx-ingress
```{{exec}}

View the generated Kubernetes manifests:
```bash
helm get manifest my-nginx-ingress -n nginx-ingress
```{{exec}}
