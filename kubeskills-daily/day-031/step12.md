## Step 12: Test template functions

```bash
cat > templates/test-funcs.yaml << 'TF'
apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ .Release.Name }}-test
data:
  # String manipulation
  upper: {{ .Values.appName | upper | quote }}
  lower: {{ .Values.appName | lower | quote }}
  title: {{ .Values.appName | title | quote }}
  
  # Defaults
  missing: {{ .Values.missing | default "default-value" | quote }}
  
  # Math (wrong - using string)
  bad-math: {{ add .Values.replicas "5" }}
TF
```

```bash
cat >> values.yaml << 'EOFVAL'
appName: "MyApplication"
EOFVAL
```

```bash
helm template myapp . 2>&1 | grep -A 20 test-funcs
```{{exec}}

Expect a type error on `bad-math`.
