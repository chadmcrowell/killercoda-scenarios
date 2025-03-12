kubectl apply -f https://github.com/kubernetes-sigs/gateway-api/releases/download/v1.2.0/standard-install.yaml

kubectl apply -f https://raw.githubusercontent.com/nginx/nginx-gateway-fabric/v1.6.2/deploy/crds.yaml

kubectl apply -f https://raw.githubusercontent.com/nginx/nginx-gateway-fabric/v1.6.2/deploy/default/deploy.yaml

kubectl apply -f https://raw.githubusercontent.com/chadmcrowell/acing-the-cka-exam/refs/heads/main/ch_06/gatewayClass-nginx-controller.yaml

