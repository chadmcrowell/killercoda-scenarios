## Step 8: Fix with default value

```bash
cat > templates/secret.yaml << 'SEC'
apiVersion: v1
kind: Secret
metadata:
  name: {{ .Release.Name }}-secret
type: Opaque
{{- if .Values.database }}
data:
  password: {{ .Values.database.password | default "changeme" | b64enc }}
{{- end }}
SEC
```

Or define the value:

```bash
cat >> values.yaml << 'EOFVAL'

database:
  password: "defaultpass"
EOFVAL
```
