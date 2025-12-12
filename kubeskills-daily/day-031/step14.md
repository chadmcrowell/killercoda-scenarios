## Step 14: Test conditional blocks

```bash
cat > templates/conditional.yaml << 'COND'
apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ .Release.Name }}-conditional
data:
  {{- if eq .Values.environment "production" }}
  log-level: "error"
  {{- else if eq .Values.environment "staging" }}
  log-level: "warn"
  {{- else }}
  log-level: "debug"
  {{- end }}
  
  {{- with .Values.monitoring }}
  monitoring-enabled: "true"
  metrics-port: {{ .port | quote }}
  {{- end }}
COND
```

```bash
cat >> values.yaml << 'EOFVAL'
environment: "staging"
monitoring:
  port: 9090
EOFVAL
```

```bash
helm template myapp .
```{{exec}}

Conditionals control log level and monitoring block rendering.
