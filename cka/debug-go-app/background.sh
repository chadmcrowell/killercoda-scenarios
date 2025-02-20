wget https://raw.githubusercontent.com/kubeskills/wolfi-debug/refs/heads/main/main.go

cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: goapp-deployment
spec:
  replicas: 1
  selector:
    matchLabels:
      app: goapp
  template:
    metadata:
      labels:
        app: goapp
    spec:
      containers:
      - name: goapp
        image: chadmcrowell/go-app:v2
        ports:
        - containerPort: 8080

EOF

kubectl expose deployment goapp-deployment --type=ClusterIP --name=goapp-service