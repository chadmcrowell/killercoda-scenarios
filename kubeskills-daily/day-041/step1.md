## Step 1: Install Prometheus Operator

```bash
kubectl create namespace monitoring

kubectl apply -f https://raw.githubusercontent.com/prometheus-operator/prometheus-operator/v0.68.0/bundle.yaml

kubectl wait --for=condition=Ready pods -l app.kubernetes.io/name=prometheus-operator -n default --timeout=120s
```{{exec}}|skip{{sandbox}}

Install the operator bundle and wait for the operator pod to be ready.
