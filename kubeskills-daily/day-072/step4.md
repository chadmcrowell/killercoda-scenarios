## Step 4: Test PodSecurityPolicy (removed in 1.25)

```bash
# PSP deprecated in 1.21, removed in 1.25
cat <<EOF > /tmp/psp.yaml
apiVersion: policy/v1beta1
kind: PodSecurityPolicy
metadata:
  name: restricted
spec:
  privileged: false
  allowPrivilegeEscalation: false
  requiredDropCapabilities:
    - ALL
  volumes:
    - 'configMap'
    - 'emptyDir'
    - 'projected'
    - 'secret'
    - 'downwardAPI'
    - 'persistentVolumeClaim'
  runAsUser:
    rule: 'MustRunAsNonRoot'
  seLinux:
    rule: 'RunAsAny'
  fsGroup:
    rule: 'RunAsAny'
EOF

kubectl apply -f /tmp/psp.yaml 2>&1 || echo "PodSecurityPolicy not supported (likely 1.25+)"

# Replacement: Pod Security Standards
kubectl label namespace default pod-security.kubernetes.io/enforce=restricted --overwrite
```{{exec}}

PodSecurityPolicy removed in 1.25, use Pod Security Standards instead.
