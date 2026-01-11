<br>

### Pod Security Standards lessons

**Key observations**

- Three profiles: privileged, baseline, restricted.
- Restricted is strict: runAsNonRoot, drop ALL caps, seccomp required.
- Three modes: enforce (block), warn (allow+warn), audit (log).
- Namespace labels define profile behavior per namespace.
- Common violations include root, privileged, hostPath, and hostNetwork.
- Some workloads legitimately need baseline rather than restricted.

**Production patterns**

```yaml
# Default namespace security
apiVersion: v1
kind: Namespace
metadata:
  name: production
  labels:
    # Enforce restricted by default
    pod-security.kubernetes.io/enforce: restricted
    pod-security.kubernetes.io/enforce-version: latest
    # Warn on baseline violations
    pod-security.kubernetes.io/warn: baseline
    pod-security.kubernetes.io/warn-version: latest
    # Audit everything
    pod-security.kubernetes.io/audit: baseline
    pod-security.kubernetes.io/audit-version: latest
```

```yaml
# Restricted-compliant Deployment
apiVersion: apps/v1
kind: Deployment
metadata:
  name: secure-app
  namespace: production
spec:
  replicas: 3
  selector:
    matchLabels:
      app: secure-app
  template:
    metadata:
      labels:
        app: secure-app
    spec:
      securityContext:
        runAsNonRoot: true
        runAsUser: 1000
        fsGroup: 1000
        seccompProfile:
          type: RuntimeDefault
      containers:
      - name: app
        image: myapp:v1.0
        securityContext:
          allowPrivilegeEscalation: false
          runAsNonRoot: true
          runAsUser: 1000
          capabilities:
            drop: ["ALL"]
          readOnlyRootFilesystem: true
        ports:
        - containerPort: 8080
        volumeMounts:
        - name: tmp
          mountPath: /tmp
        - name: cache
          mountPath: /app/cache
      volumes:
      - name: tmp
        emptyDir: {}
      - name: cache
        emptyDir: {}
```

```yaml
# Baseline for system workloads
apiVersion: v1
kind: Namespace
metadata:
  name: monitoring
  labels:
    # Baseline for monitoring tools that need hostPath
    pod-security.kubernetes.io/enforce: baseline
    pod-security.kubernetes.io/enforce-version: latest
    pod-security.kubernetes.io/warn: baseline
    pod-security.kubernetes.io/audit: restricted
```

```bash
# Migration strategy
# Step 1: Audit mode first (no enforcement)
kubectl label namespace production \
  pod-security.kubernetes.io/audit=restricted \
  pod-security.kubernetes.io/warn=restricted

# Step 2: Review violations
kubectl get events -n production | grep "violates PodSecurity"

# Step 3: Fix workloads
# Update deployments to be compliant

# Step 4: Enforce
kubectl label namespace production \
  pod-security.kubernetes.io/enforce=restricted --overwrite
```

```bash
# Check compliance script
#!/bin/bash
# check-pod-security.sh

echo "=== Pod Security Compliance Check ==="

for ns in $(kubectl get ns -o jsonpath='{.items[*].metadata.name}'); do
  echo -e "\nNamespace: $ns"
  
  # Get PSA labels
  enforce=$(kubectl get ns $ns -o jsonpath='{.metadata.labels.pod-security\.kubernetes\.io/enforce}' 2>/dev/null || echo "none")
  warn=$(kubectl get ns $ns -o jsonpath='{.metadata.labels.pod-security\.kubernetes\.io/warn}' 2>/dev/null || echo "none")
  
  echo "  Enforce: $enforce"
  echo "  Warn: $warn"
  
  # Count pods
  pod_count=$(kubectl get pods -n $ns --no-headers 2>/dev/null | wc -l)
  echo "  Pods: $pod_count"
done

echo -e "\n=== Recommendations ==="
echo "1. Set enforce=restricted for application namespaces"
echo "2. Use enforce=baseline for system namespaces"
echo "3. Always enable audit=restricted for visibility"
```

**Cleanup**

```bash
kubectl delete namespace privileged-ns baseline-ns restricted-ns warn-ns system-ns
```{{exec}}

---

Next: Day 58 - Ingress Failures - Traffic Not Routing
