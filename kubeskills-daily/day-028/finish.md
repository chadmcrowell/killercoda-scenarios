<br>

### Pod Security enforced

**Key observations**

✅ PSA profiles: privileged (allow all), baseline (minimal), restricted (strict hardening).  
✅ Namespace labels control enforce/warn/audit; multiple violations are listed in one error.  
✅ Restricted demands seccomp RuntimeDefault, non-root, no privilege escalation, and minimal capabilities.  
✅ Admission blocks non-compliant pods before they start; warn/audit modes surface issues without blocking.  
✅ Works for all workload types: Pods, Deployments, StatefulSets, etc.

**Production patterns**

Development namespace (warn only):

```yaml
metadata:
  labels:
    pod-security.kubernetes.io/enforce: "privileged"
    pod-security.kubernetes.io/warn: "restricted"
    pod-security.kubernetes.io/audit: "restricted"
```

Production namespace (strict):

```yaml
metadata:
  labels:
    pod-security.kubernetes.io/enforce: "restricted"
    pod-security.kubernetes.io/enforce-version: "latest"
```

Migration strategy (baseline first):

```yaml
metadata:
  labels:
    pod-security.kubernetes.io/enforce: "baseline"
    pod-security.kubernetes.io/warn: "restricted"
```

Restricted-compliant pod template:

```yaml
spec:
  securityContext:
    runAsNonRoot: true
    runAsUser: 1000
    fsGroup: 1000
    seccompProfile:
      type: RuntimeDefault
  containers:
  - name: app
    image: myapp:latest
    securityContext:
      allowPrivilegeEscalation: false
      runAsNonRoot: true
      runAsUser: 1000
      capabilities:
        drop: ["ALL"]
        add: ["NET_BIND_SERVICE"]  # Only if needed
```

**Cleanup**

```bash
kubectl delete namespace psa-baseline psa-restricted psa-mixed psa-privileged 2>/dev/null
```{{exec}}

---

🎉 Week 4 Complete! Day 28 Achievement Unlocked!
