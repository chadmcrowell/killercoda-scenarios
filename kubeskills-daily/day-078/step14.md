## Step 14: Defense mechanisms

```bash
cat > /tmp/container-security-defenses.md << 'OUTER'
# Container Security Defenses

## Pod Security Standards

### Restricted Profile (Most Secure)
apiVersion: v1
kind: Namespace
metadata:
  name: secure-namespace
  labels:
    pod-security.kubernetes.io/enforce: restricted
    pod-security.kubernetes.io/audit: restricted
    pod-security.kubernetes.io/warn: restricted

### Restricted Pod Requirements
- runAsNonRoot: true
- allowPrivilegeEscalation: false
- capabilities: drop ALL
- readOnlyRootFilesystem: true
- seccompProfile: RuntimeDefault

## Security Best Practices

1. Never use privileged containers
2. Drop all capabilities, add only what is needed
3. Run as non-root (runAsUser: 1000+)
4. Read-only root filesystem with emptyDir for writable paths
5. Enable seccomp (RuntimeDefault or custom profile)
6. Use AppArmor/SELinux
7. Avoid hostPath volumes (use PVC or emptyDir)
8. Never mount Docker socket
9. Disable host namespaces (hostPID/hostNetwork/hostIPC)
10. Use NetworkPolicies

## Runtime Security (Falco)
- Detect shell spawned in container
- Detect writes below root filesystem
- Detect sensitive file access

## Policy Enforcement (OPA Gatekeeper)
- Block privileged containers
- Require runAsNonRoot
- Block hostPath volumes

## Incident Response
1. Isolate affected node
2. Drain workloads to other nodes
3. Collect forensics (logs, memory dump)
4. Terminate compromised containers
5. Patch and rebuild images
6. Review security policies
7. Implement additional controls
OUTER

cat /tmp/container-security-defenses.md
```{{exec}}

Complete defense guide covering Pod Security Standards, runtime security, policy enforcement, and incident response.
