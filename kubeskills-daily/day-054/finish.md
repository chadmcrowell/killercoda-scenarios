<br>

### Certificate rotation lessons

**Key observations**

- kubelet auto-rotation (rotateCertificates) prevents client cert expiry.
- cert-manager automates app/webhook cert lifecycles; failures show in events.
- Webhooks need caBundle updates when certs change; short timeouts reduce impact.
- Expiring certs give no native warnings—monitor expirations proactively.
- Deleting secrets forces cert-manager to re-issue certs.
- Root CA rotation is complex and needs careful staging.

**Production patterns**

```yaml
# Prometheus alerts
- alert: CertificateExpiringSoon
  expr: (certmanager_certificate_expiration_timestamp_seconds - time()) < 604800
  for: 1h
- alert: CertificateRenewalFailed
  expr: certmanager_certificate_ready_status{condition="False"} == 1
  for: 1h
```

```yaml
# cert-manager ClusterIssuer example
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: letsencrypt-prod
spec:
  acme:
    server: https://acme-v02.api.letsencrypt.org/directory
    email: admin@example.com
    privateKeySecretRef:
      name: letsencrypt-prod
    solvers:
    - http01:
        ingress:
          class: nginx
```

```bash
# Kubelet rotation settings
rotateCertificates: true
serverTLSBootstrap: true
```

**Cleanup**

```bash
kubectl delete certificate short-lived-cert expire-test webhook-cert 2>/dev/null
kubectl delete issuer test-issuer 2>/dev/null
kubectl delete validatingwebhookconfiguration test-webhook 2>/dev/null
rm -f /tmp/check-certs.sh /tmp/cert-rotation-plan.md /tmp/cert.crt /tmp/ca.crt
```{{exec}}

---

Next: Day 55 - TBD
