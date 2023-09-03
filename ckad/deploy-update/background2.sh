kubectl -n session283884 expose deploy scaler --port 80 --type NodePort --dry-run=client -o yaml > svc.yaml

sleep 2

sed -i 's|targetPort: 80|nodePort: 30942|g' ./svc.yaml

sleep 2

kubectl apply -f ./svc.yaml

sed -i 's/PORT/30942/g' /etc/killercoda/host

# Read the contents of the file
data=$(cat /etc/killercoda/host)

# Append the HTML link to the file
# echo -e "\n\n<a href=\"$data\">Link Name</a>\n"