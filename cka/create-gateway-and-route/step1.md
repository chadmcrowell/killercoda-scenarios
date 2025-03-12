[Quick References](https://gateway-api.sigs.k8s.io/guides/)

The Gateway API CRDs are already installed in your cluster. View them using the `kubectl` command line.


<br>
<details><summary>Solution</summary>
<br>

```bash
# list the API CRDs and grep out the ones installed for Gateway API
kubectl get crds | grep gateway

```{{exec}}

</details>