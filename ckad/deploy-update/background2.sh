kubectl -n session283884 expose deploy scaler --port 80 --type NodePort --dry-run=client -o yaml > svc.yaml

sed -i 's|targetPort: 80|nodePort: 30942|g' ./svc.yaml

kubectl apply -f ./svc.yaml