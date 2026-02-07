## Step 15: Proper secret management

```bash
cat > /tmp/secret-management-guide.md << 'OUTER'
# Proper Secret Management in Kubernetes

## DO NOT

- Store secrets in Git (even base64 encoded)
- Log secrets to stdout/stderr
- Hardcode secrets in Dockerfiles
- Use ConfigMaps for sensitive data
- Grant broad secret access via RBAC
- Use default ServiceAccount for apps
- Mount secrets as env vars if avoidable

## DO

- Use external secret managers (Vault, AWS SM, Azure KV, GCP SM)
- Use Kubernetes secret tools (SealedSecrets, External Secrets Operator, SOPS)
- Encrypt secrets at rest (enable etcd encryption, use KMS provider)
- Implement least-privilege RBAC (specific secret names only)
- Mount secrets as volumes (not env vars)
- Rotate secrets regularly with automation
- Audit secret access via audit logging
- Scan for leaked secrets (git-secrets, TruffleHog, GitGuardian)

## Least Privilege RBAC Example

apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: app-secrets
rules:
- apiGroups: [""]
  resources: ["secrets"]
  resourceNames: ["app-db-creds"]
  verbs: ["get"]

## Volume Mount Example

volumes:
- name: secrets
  secret:
    secretName: app-secrets
    defaultMode: 0400
volumeMounts:
- name: secrets
  mountPath: /secrets
  readOnly: true

## Best Practices Summary

1. Never commit secrets to Git
2. Use external secret managers
3. Encrypt secrets at rest (etcd encryption)
4. Implement least-privilege RBAC
5. Rotate secrets regularly
6. Audit secret access
7. Scan for leaked secrets
8. Mount secrets as volumes, not env vars
9. Use short-lived credentials when possible
10. Monitor and alert on unusual access
OUTER

cat /tmp/secret-management-guide.md
```{{exec}}

Complete secret management guide covering anti-patterns and production-ready best practices.
