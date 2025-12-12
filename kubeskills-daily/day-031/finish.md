<br>

### Helm templates debugged

**Key observations**

✅ Go templates power Helm; syntax errors halt rendering.  
✅ `required` guards critical values; default filters and `if`/`with` prevent nil pointers.  
✅ Value precedence: `--set` > `-f override.yaml` > `values.yaml`.  
✅ Functions are type-sensitive; ensure correct value types.  
✅ `helm template`, `helm lint`, dry-run, and history/rollback make debugging safe.

**Production patterns**

```yaml
{{- if .Values.feature }}
{{- $_ := required "feature.enabled must be set" .Values.feature.enabled }}
feature:
  enabled: {{ .Values.feature.enabled | default false }}
{{- end }}
```

Named helpers keep names consistent:

```yaml
{{- define "myapp.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name .Chart.Name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
```

**Cleanup**

```bash
helm uninstall myapp-release
cd ..
rm -rf myapp override.yaml
```{{exec}}

---

Next: Day 32 - GitOps Sync Failures with ArgoCD
