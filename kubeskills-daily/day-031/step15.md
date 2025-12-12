## Step 15: Test range loops

```bash
cat > templates/loop.yaml << 'LOOP'
apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ .Release.Name }}-loop
data:
  {{- range .Values.environments }}
  env-{{ . }}: "enabled"
  {{- end }}
  
  {{- range $key, $val := .Values.config }}
  {{ $key }}: {{ $val | quote }}
  {{- end }}
LOOP
```

```bash
cat >> values.yaml << 'EOFVAL'
environments:
  - dev
  - staging
  - prod
  
config:
  timeout: "30s"
  retries: "3"
EOFVAL
```

```bash
helm template myapp .
```{{exec}}

Ranges emit repeated blocks for lists and maps.
