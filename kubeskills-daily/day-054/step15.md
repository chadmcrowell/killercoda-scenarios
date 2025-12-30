## Step 15: Document rotation procedures

```bash
cat > /tmp/cert-rotation-plan.md << 'EOF'
# Certificate Rotation Plan

## Kubernetes Core Certificates
### API Server
- Location: /etc/kubernetes/pki/apiserver.crt
- Rotation: `kubeadm certs renew apiserver`
- Frequency: Annually (by default)
- Impact: Brief API unavailability during restart

### Kubelet
- Location: /var/lib/kubelet/pki/
- Rotation: Automatic (if enabled)
- Config: `rotateCertificates: true` in kubelet config
- Frequency: Before expiration

### Controller Manager & Scheduler
- Location: /etc/kubernetes/pki/
- Rotation: `kubeadm certs renew all`
- Impact: Controller/scheduler restart

## Service Mesh Certificates
### Istio
- Rotation: Automatic via istiod
- Root CA: Manual rotation required
- Workload certs: 24h lifetime, auto-rotate

### Linkerd
- Rotation: linkerd-identity manages
- Root CA: Manual with `linkerd install`
- Workload certs: 24h lifetime

## Application Certificates (cert-manager)
### Monitoring
kubectl get certificate -A -o custom-columns=\
  NS:.metadata.namespace,\
  NAME:.metadata.name,\
  EXPIRY:.status.notAfter

kubectl get certificate -A -o json | jq -r '
  .items[] |
  select(.status.renewalTime != null) |
  select((.status.renewalTime | fromdateiso8601) < now + 2592000) |
  .metadata.name
'

### Renewal
- Automatic: cert-manager handles
- Manual: Delete secret to force renewal
- Failure: Check issuer, DNS, ACME challenges

## Emergency Procedures
### API Server Cert Expired
1. SSH to control plane node
2. Run: `kubeadm certs renew apiserver`
3. Restart: `systemctl restart kubelet`
4. Verify: `kubectl get nodes`

### Webhook Cert Expired
1. Delete webhook configuration temporarily
2. Renew certificate
3. Update caBundle in webhook config
4. Reapply webhook configuration

### CA Rotation (Advanced)
1. Generate new CA
2. Add to trust store alongside old CA
3. Issue new certs from new CA
4. Remove old CA after all certs renewed
EOF

cat /tmp/cert-rotation-plan.md
```{{exec}}

Document rotation playbooks for Kubernetes core, cert-manager, and service meshes.
