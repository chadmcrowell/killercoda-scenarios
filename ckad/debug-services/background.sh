kubectl create deployment hostnames --replicas=3 --image=registry.k8s.io/serve_hostname

kubectl expose deployment hostnames --port=80 --target-port=9376