## Step 20: Check exemptions

```bash
# Exemptions allow specific users/namespaces/images to bypass PSA
# Configured at API server level with --admission-control-config-file

cat << 'EOF'
Example exemption config:
apiVersion: apiserver.config.k8s.io/v1
kind: AdmissionConfiguration
plugins:
- name: PodSecurity
  configuration:
    apiVersion: pod-security.admission.config.k8s.io/v1
    kind: PodSecurityConfiguration
    defaults:
      enforce: "baseline"
      audit: "restricted"
      warn: "restricted"
    exemptions:
      usernames: []
      runtimeClasses: []
      namespaces: ["kube-system"]
EOF
```{{exec}}

Exemptions are set at the API server and not per-namespace.
