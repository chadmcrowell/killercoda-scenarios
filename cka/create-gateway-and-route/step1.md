[Quick References](https://gateway-api.sigs.k8s.io/guides/)

The Gateway API CRDs are already installed in your cluster. View them using the `kubectl` command line.


<br>
<details><summary>Solution</summary>
<br>

```bash
# list the API CRDs and grep out the ones installed for Gateway API
kubectl get crds | grep gateway

```{{exec}}

The output should look like this before proceeding
```bash
clientsettingspolicies.gateway.nginx.org              2025-03-12T12:46:10Z
gatewayclasses.gateway.networking.k8s.io              2025-03-12T12:46:03Z
gateways.gateway.networking.k8s.io                    2025-03-12T12:46:04Z
grpcroutes.gateway.networking.k8s.io                  2025-03-12T12:46:05Z
httproutes.gateway.networking.k8s.io                  2025-03-12T12:46:06Z
nginxgateways.gateway.nginx.org                       2025-03-12T12:46:11Z
nginxproxies.gateway.nginx.org                        2025-03-12T12:46:12Z
observabilitypolicies.gateway.nginx.org               2025-03-12T12:46:12Z
referencegrants.gateway.networking.k8s.io             2025-03-12T12:46:08Z
snippetsfilters.gateway.nginx.org                     2025-03-12T12:46:13Z
upstreamsettingspolicies.gateway.nginx.org            2025-03-12T12:46:13Z
```

</details>