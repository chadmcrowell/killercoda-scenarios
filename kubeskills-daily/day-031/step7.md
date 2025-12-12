## Step 7: Test nil pointer dereference

```bash
cat > templates/secret.yaml << 'SEC'
apiVersion: v1
kind: Secret
metadata:
  name: {{ .Release.Name }}-secret
type: Opaque
data:
  # .Values.database doesn't exist!
  password: {{ .Values.database.password | b64enc }}
SEC
```

```bash
helm template myapp . 2>&1
```{{exec}}

Expect a nil pointer error when accessing a missing value.
