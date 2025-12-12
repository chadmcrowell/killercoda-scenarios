## Step 13: Fix function types

```bash
cat > templates/test-funcs.yaml << 'TF'
apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ .Release.Name }}-test
data:
  upper: {{ .Values.appName | upper | quote }}
  good-math: {{ add .Values.replicaCount 5 | quote }}
  list: {{ list "a" "b" "c" | join "," | quote }}
  dict: {{ dict "key1" "val1" "key2" "val2" | toJson }}
TF
```

```bash
helm template myapp .
```{{exec}}

Math now uses the integer `replicaCount` value.
