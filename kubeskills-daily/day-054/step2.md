## Step 2: Check kubelet certificate rotation

```bash
kubectl get cm kubelet-config -n kube-system -o yaml | grep -i rotateCertificates
ls -la /var/lib/kubelet/pki/ 2>/dev/null || echo "Kubelet PKI not accessible"
```{{exec}}

Verify kubelet auto-rotation settings and certificate files (if visible).
