echo "Deploying scenario..."

kubectl wait --for=condition=ready --timeout=300s pod -l app.kubernetes.io/name=prometheus -n default