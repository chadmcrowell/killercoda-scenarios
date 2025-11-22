## Step 9: Using HashiCorp Vault agent (conceptual)

```yaml
# This is a conceptual example - requires Vault installation
apiVersion: v1
kind: Pod
metadata:
  name: vault-app
  annotations:
    vault.hashicorp.com/agent-inject: "true"
    vault.hashicorp.com/role: "myapp"
    vault.hashicorp.com/agent-inject-secret-db-creds: "secret/data/myapp/db"
    vault.hashicorp.com/agent-inject-template-db-creds: |
      {{- with secret "secret/data/myapp/db" -}}
      export DB_USER="{{ .Data.data.username }}"
      export DB_PASS="{{ .Data.data.password }}"
      {{- end }}
spec:
  containers:
  - name: app
    image: myapp:latest
    command: ['sh', '-c', 'source /vault/secrets/db-creds && ./start.sh']
```

Vault agents can inject fresh secrets and templates into pods, avoiding static Kubernetes secrets for highly sensitive credentials.
