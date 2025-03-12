A **Gateway** in Kubernetes is a networking resource that controls external traffic into a cluster, supporting **HTTP, HTTPS, TCP, and UDP** protocols. It acts as a **central entry point**, replacing Ingress, and works with **GatewayClasses** and **Routes (HTTPRoute, TCPRoute, UDPRoute)** for flexible traffic management.

A **GatewayClass** defines the **implementation** of a `Gateway`, specifying which controller (e.g., NGINX, Istio, Cilium) will manage it. It acts as a **template** for Gateways, similar to how `storageClass` works for PersistentVolumes.

Install a basic Gateway resource named `my-gateway` in the default namespace. The gateway should be based on the gateway class `nginx`. You can view the `gatewayClass` with the command `kubectl get gatewayclass`.

The gateway will be listening on port 80.

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