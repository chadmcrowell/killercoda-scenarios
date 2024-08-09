echo "Deploying scenario..." && sleep 10

kubectl wait --for=condition=ready --timeout=300s pod -l app.kubernetes.io/name=prometheus -n default