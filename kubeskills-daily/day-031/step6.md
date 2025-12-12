## Step 6: Fix template syntax

```bash
cat > templates/configmap.yaml << 'CM'
apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ .Release.Name }}-config
  {{- if .Values.annotations }}
  annotations:
    {{- range $key, $val := .Values.annotations }}
    {{ $key }}: {{ $val }}
    {{- end }}
  {{- end }}  # Fixed!
data:
  app.conf: |
    server:
      port: {{ .Values.service.port }}
CM
```

```bash
helm template myapp .
```{{exec}}

Templates now render successfully.
