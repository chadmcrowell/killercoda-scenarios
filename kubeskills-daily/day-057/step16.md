## Step 16: Check which fields violate restricted

```bash
# List all restricted requirements
cat << 'EOF'
Restricted Profile Requirements:
1. runAsNonRoot: true
2. allowPrivilegeEscalation: false
3. capabilities.drop: ["ALL"]
4. seccompProfile.type: RuntimeDefault or Localhost
5. No privileged containers
6. No host namespaces (hostNetwork, hostPID, hostIPC)
7. No hostPath volumes
8. Volume types limited (no hostPath, gcePersistentDisk, etc)
9. AppArmor profile (runtime/default)
10. SELinux must be unset or specific values
EOF
```{{exec}}

Use these requirements to spot violations quickly.
