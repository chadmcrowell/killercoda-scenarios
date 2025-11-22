<br>

### Secrets rotated (mostly)

**Key observations**

✅ Env vars are frozen at pod creation—restart to pick up changes.  
✅ Secret volumes refresh on the kubelet sync loop (~60s).  
✅ Immutable secrets block edits; delete/recreate to change.  
✅ base64 is not encryption—enable EncryptionConfiguration + KMS for at-rest protection.

**Production patterns**

External Secrets Operator:

```yaml
apiVersion: external-secrets.io/v1beta1
kind: ExternalSecret
metadata:
  name: db-secret
spec:
  refreshInterval: 1h
  secretStoreRef:
    name: aws-secrets-manager
    kind: ClusterSecretStore
  target:
    name: db-credentials
  data:
  - secretKey: password
    remoteRef:
      key: prod/myapp/db
      property: password
```

Sealed Secrets (GitOps-safe):

```bash
kubeseal --format yaml < secret.yaml > sealed-secret.yaml
```{{exec}}

**Cleanup**

```bash
kubectl delete deployment rotating-app 2>/dev/null
kubectl delete pod secret-app projected-secret 2>/dev/null
kubectl delete secret db-credentials immutable-secret 2>/dev/null
```{{exec}}

---

Next: Day 11 - Service DNS Propagation Delays
