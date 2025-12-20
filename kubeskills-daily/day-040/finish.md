<br>

### Certificate expiration lessons

**Key observations**

- Control plane certs expire; kubeadm can report dates.
- No grace period: expired certs break auth immediately.
- cert-manager automates issuance and renewal; renewBefore defines lead time.
- CA chains must be valid; Issuers/ClusterIssuers define trust scope.
- Breaking issuers stops renewals; restoring them resumes.

**Production patterns**

```yaml
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

```yaml
apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: ingress-cert
spec:
  secretName: ingress-tls
  duration: 2160h
  renewBefore: 720h
  issuerRef:
    name: letsencrypt-prod
    kind: ClusterIssuer
  dnsNames:
  - example.com
  - www.example.com
```

```bash
kubectl get certificate -A -o json | jq -r '.items[] | "\(.metadata.namespace)/\(.metadata.name): \(.status.notAfter)"'
```

**Cleanup**

```bash
kubectl delete certificate short-lived-cert expired-cert app-cert cross-ns-cert webhook-cert ca-cert 2>/dev/null
kubectl delete issuer selfsigned-issuer ca-issuer 2>/dev/null
kubectl delete clusterissuer cluster-selfsigned 2>/dev/null
kubectl delete deployment webhook 2>/dev/null
kubectl delete service webhook-service 2>/dev/null
kubectl delete namespace other-ns cert-manager 2>/dev/null
```{{exec}}

---

Next: Day 41 - TBD
