<br>

### Helm failure lessons

**Key observations**

- Template errors are caught at render time.
- Required values block installation when missing.
- Hooks can fail and block deployments.
- Upgrades can conflict with existing resources.
- Rollbacks create a new revision.
- Dependencies must be updated before install.

**Production patterns**

```text
mychart/
  Chart.yaml          # Chart metadata
  values.yaml         # Default values
  charts/             # Chart dependencies
  templates/          # Kubernetes manifests
    deployment.yaml
    service.yaml
    ingress.yaml
    _helpers.tpl      # Template helpers
    NOTES.txt         # Post-install notes
  .helmignore        # Files to ignore
```

```yaml
# Default values for mychart
replicaCount: 2

image:
  repository: myapp
  tag: ""  # Overridden by CI/CD
  pullPolicy: IfNotPresent

imagePullSecrets: []

nameOverride: ""
fullnameOverride: ""

serviceAccount:
  create: true
  annotations: {}
  name: ""

podAnnotations: {}

podSecurityContext:
  runAsNonRoot: true
  runAsUser: 1000
  fsGroup: 1000

securityContext:
  allowPrivilegeEscalation: false
  capabilities:
    drop:
    - ALL
  readOnlyRootFilesystem: true

service:
  type: ClusterIP
  port: 80

ingress:
  enabled: false
  className: nginx
  annotations: {}
  hosts:
    - host: chart-example.local
      paths:
        - path: /
          pathType: Prefix
  tls: []

resources:
  limits:
    cpu: 100m
    memory: 128Mi
  requests:
    cpu: 100m
    memory: 128Mi

autoscaling:
  enabled: false
  minReplicas: 2
  maxReplicas: 10
  targetCPUUtilizationPercentage: 80

nodeSelector: {}

tolerations: []

affinity: {}
```

```yaml
{{/*
Expand the name of the chart.
*/}}
{{- define "mychart.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
*/}}
{{- define "mychart.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "mychart.labels" -}}
helm.sh/chart: {{ include "mychart.chart" . }}
{{ include "mychart.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "mychart.selectorLabels" -}}
app.kubernetes.io/name: {{ include "mychart.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}
```

```bash
#!/bin/bash
# deploy.sh

NAMESPACE="production"
RELEASE_NAME="myapp"
CHART_PATH="./charts/myapp"

# Validate chart
helm lint $CHART_PATH

# Dry run
helm upgrade --install $RELEASE_NAME $CHART_PATH \
  --namespace $NAMESPACE \
  --create-namespace \
  --values $CHART_PATH/values-${ENVIRONMENT}.yaml \
  --set image.tag=${CI_COMMIT_SHA} \
  --dry-run \
  --debug

# Deploy
helm upgrade --install $RELEASE_NAME $CHART_PATH \
  --namespace $NAMESPACE \
  --create-namespace \
  --values $CHART_PATH/values-${ENVIRONMENT}.yaml \
  --set image.tag=${CI_COMMIT_SHA} \
  --wait \
  --timeout 5m

# Verify deployment
kubectl rollout status deployment/${RELEASE_NAME} -n $NAMESPACE

# Run tests
helm test $RELEASE_NAME -n $NAMESPACE
```

```bash
#!/bin/bash
# rollback.sh

NAMESPACE="production"
RELEASE_NAME="myapp"

# Check current status
helm status $RELEASE_NAME -n $NAMESPACE

# Show history
helm history $RELEASE_NAME -n $NAMESPACE

# Rollback to previous
helm rollback $RELEASE_NAME -n $NAMESPACE --wait

# Verify
kubectl get pods -n $NAMESPACE -l app.kubernetes.io/instance=$RELEASE_NAME
```

**Cleanup**

```bash
helm uninstall test-release dep-test conflict-test 2>/dev/null
rm -rf /tmp/mycharts /tmp/override-values.yaml /tmp/orphan.yaml
```{{exec}}

---

Week 9 complete: Day 61 - Helm Chart Deployment Failures
