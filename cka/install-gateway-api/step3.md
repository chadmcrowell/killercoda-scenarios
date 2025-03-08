Install a basic Gateway resource in your Kubernetes cluster.

Using `kubectl`, verify that the Gateway is running.

> NOTE: Because we can't create ingress resources in Killercoda, the gateway will not be assigned an IP.

<br>
<details><summary>Solution</summary>
<br>

```bash
# Deploy a basic Gateway that allows access to port 80 into the cluster
cat <<EOF | kubectl apply -f -
apiVersion: gateway.networking.k8s.io/v1
kind: Gateway
metadata:
 name: my-gateway
 namespace: default
spec:
 gatewayClassName: nginx
 listeners:
 - name: http
   protocol: HTTP
   port: 80
EOF
```{{exec}}

```bash
# check if the Gateway has been created
kubectl get gateway
```{{exec}}

</details>