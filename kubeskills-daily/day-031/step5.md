## Step 5: Introduce template syntax error

```bash
cat > templates/configmap.yaml << 'CM'
apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ .Release.Name }}-config
  {{- if .Values.annotations }}  # Opening if
  annotations:
    {{- range $key, $val := .Values.annotations }}
    {{ $key }}: {{ $val }}
    {{- end }}
  # Missing {{- end }} for if!
data:
  app.conf: |
    server:
      port: {{ .Values.service.port }}
CM
```

```bash
helm template myapp . 2>&1 | grep -i error
```{{exec}}

Expect an "unexpected EOF" due to the missing `end`.
