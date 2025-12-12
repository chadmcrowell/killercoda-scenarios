## Step 9: Test required values

```bash
cat > templates/secret.yaml << 'SEC'
apiVersion: v1
kind: Secret
metadata:
  name: {{ .Release.Name }}-secret
type: Opaque
data:
  password: {{ required "database.password is required!" .Values.database.password | b64enc }}
SEC
```

Remove database section:

```bash
sed -i '/^database:/,+1d' values.yaml
```

```bash
helm template myapp . 2>&1 | grep -i required
```{{exec}}

Rendering fails with the required message when the value is absent.
