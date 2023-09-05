kubectl -n session283884 expose deploy scaler --port 80 --type NodePort --dry-run=client -o yaml > svc.yaml

sleep 2

sed -i 's|targetPort: 80|nodePort: 30942|g' ./svc.yaml

sleep 2

kubectl apply -f ./svc.yaml

# sed -i 's/PORT/30942/g' /etc/killercoda/host

# Read the contents of the file
# DATA=$(cat /etc/killercoda/host)

# Append the HTML link to the file
# echo -e "\n\n<a href=\"$data\">Link Name</a>\n"

# Path to the file
# file_path="/etc/killercoda/host"

# Read the first line of the file
# first_line=$(head -n 1 $file_path)

# Format as an HTML link and print
# echo "<a href=\"$first_line\">Link</a>"