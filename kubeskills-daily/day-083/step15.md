## Step 15: StatefulSet troubleshooting guide

```bash
cat > /tmp/statefulset-troubleshooting.md << 'EOF'
# StatefulSet Troubleshooting Guide

## Common Issues

### 1. Pod Stuck in Pending
kubectl describe pod <pod-name>
kubectl get pvc
kubectl get events --sort-by='.lastTimestamp'

Causes: no storage class, insufficient capacity, volume still attached to old node

### 2. Pod CrashLoopBackOff
kubectl logs <pod-name>
kubectl logs <pod-name> --previous
kubectl describe pod <pod-name>

Causes: wrong cluster init config, env vars not set, volume mount issues

### 3. DNS Resolution Fails
kubectl get svc
kubectl run dns-test --rm -i --image=busybox -- nslookup <svc-name>

Causes: headless service missing, selector mismatch, CoreDNS issues

### 4. Scaling Issues
kubectl get sts <name> -o jsonpath='{.spec.updateStrategy}'
kubectl get pdb

Causes: OnDelete strategy, partition set, PDB blocking, volume still attached

### 5. Data Loss After Restart
kubectl get pvc
kubectl get pod <pod-name> -o yaml | grep -A 10 volumeMounts

Causes: volumeClaimTemplates missing, wrong mount path, emptyDir used, PVC deleted

### 6. Split-Brain
kubectl exec <pod-0> -- nc -zv <pod-1>.<svc> <port>
kubectl exec <pod-0> -- cat /config/cluster.conf

Causes: network partition, wrong cluster init, quorum miscalculation

### 7. PVC Won't Delete
kubectl describe pvc <pvc-name> | grep "Used By"
kubectl patch pvc <pvc-name> -p '{"metadata":{"finalizers":null}}'

Causes: pod still using PVC, finalizers present, volume plugin issue

## Best Practices
- Always pair StatefulSet with a headless service (clusterIP: None)
- Set terminationGracePeriodSeconds >= your app shutdown time
- Use podAntiAffinity to spread replicas across nodes
- Use lifecycle.preStop hooks for clean database shutdown
- Monitor with kube_statefulset_status_replicas_ready != kube_statefulset_replicas
- Back up PVCs before scaling down or deleting the StatefulSet

## Recovery Procedures

Scale to 0, fix config, scale back up:
  kubectl scale statefulset <name> --replicas=0
  kubectl edit statefulset <name>
  kubectl scale statefulset <name> --replicas=3
  kubectl rollout status statefulset <name>
EOF

cat /tmp/statefulset-troubleshooting.md
```{{exec}}

A systematic troubleshooting guide covering the seven most common StatefulSet failure modes, along with best practices and recovery procedures for production environments.
