[Quick References](https://gateway-api.sigs.k8s.io/api-types/httproute/)

An **HTTPRoute** in Kubernetes defines **routing rules** for HTTP traffic, specifying how requests are forwarded from a **Gateway** to backend services. It supports **host-based, path-based, and header-based routing**, along with traffic splitting, retries, and filters.

Create a new `HTTPRoute` named `web-route` that will direct HTTP traffic to the underlying `web` service created in the previous step. Use path-based routing, and ensure all traffic to the domain handled by `my-gateway` is routed to the web service (setting the path to the root of the domain).

> NOTE: Killercoda will not allow ingress resources, so you will not see any hostnames or IP information for the Gateway. This is expected.

<br>
<details><summary>Solution</summary>
<br>

```bash
# create an HTTPRoute named `web-route` and direct HTTP requests to the service `web` on port 80
cat <<EOF | kubectl apply -f -
apiVersion: gateway.networking.k8s.io/v1
kind: HTTPRoute
metadata:
  name: web-route
  namespace: default
spec:
  parentRefs:
  - name: my-gateway
  rules:
  - matches:
    - path:
        type: PathPrefix
        value: "/"
    backendRefs:
    - name: web
      port: 80
EOF
```{{exec}}

```bash
# verify the httpRoute has been created
kubectl get httproute
```{{exec}}

</details>