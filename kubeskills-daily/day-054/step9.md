## Step 9: Service mesh certificate rotation (conceptual)

```bash
echo "Service mesh certificate rotation:"
echo "- Istio: Managed by istiod (auto-rotates workload certs)"
echo "- Linkerd: Managed by linkerd-identity"
echo "- Root CA rotation requires manual steps"
echo "- Workload certs rotate automatically (often 24h)"
```{{exec}}

Mesh certs are separate from Kubernetes core certs.
