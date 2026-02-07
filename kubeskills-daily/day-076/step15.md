## Step 15: GitOps troubleshooting guide

```bash
cat > /tmp/gitops-troubleshooting.md << 'OUTER'
# GitOps Troubleshooting Guide

## Sync Not Happening

### Check 1: Webhook Delivery
# Check webhook configuration
kubectl get cm -n argocd argocd-cm -o yaml | grep webhook

# Test webhook endpoint
curl -X POST https://argocd.example.com/api/webhook \
  -H "Content-Type: application/json" \
  -d '{"ref":"refs/heads/main"}'

### Check 2: Repository Access
# Test Git connectivity
kubectl exec -n argocd argocd-repo-server-xxx -- \
  git ls-remote https://github.com/org/repo.git

### Check 3: Manifest Validation
# Validate locally
kubectl apply --dry-run=server -k ./overlays/prod

# Check Kustomize build
kubectl kustomize ./overlays/prod

## Out of Sync Status

### Check Drift
# Compare Git to cluster
kubectl diff -k ./overlays/prod

# Show differences
argocd app diff myapp

### Check Health
# Application health
argocd app get myapp

# Resource health
kubectl get pods -l app=myapp

## Sync Failures

### Check Logs
# ArgoCD application controller
kubectl logs -n argocd -l app.kubernetes.io/name=argocd-application-controller

# Sync operation logs
argocd app logs myapp

### Check Events
# Application events
kubectl get events -n argocd --sort-by='.lastTimestamp'

# Resource events
kubectl get events -n production --sort-by='.lastTimestamp'

## Common Issues

### Issue: Auto-prune Deleted Live Resources
Symptom: Resources disappear from cluster
Cause: Removed from Git, auto-prune enabled
Fix: Disable auto-prune, use Prune=false sync option

### Issue: Sync Loops
Symptom: Constant syncing, never healthy
Cause: Generated fields, failing health checks, circular dependencies
Fix: Add ignore differences, fix health checks, break cycles

### Issue: Wrong Resource Version
Symptom: "the object has been modified"
Cause: Resource updated outside GitOps
Fix: Enforce GitOps only via RBAC, revert manual changes

### Issue: CRD Apply Fails
Symptom: "no matches for kind"
Cause: CRD not installed
Fix: Use sync waves (CRD first), apply CRDs in separate app

### Issue: Webhook Not Triggering
Symptom: Push to Git, no sync
Cause: Wrong URL, auth failure, network policy blocking
Fix: Verify config, check secret, test delivery

## Best Practices

1. Validate before merge (CI pipeline)
2. Use sync waves for dependency ordering
3. Test in staging first
4. Monitor sync status and alert on failures
5. No secrets in Git (use SealedSecrets/ESO)
6. Have a rollback plan (git revert)
OUTER

cat /tmp/gitops-troubleshooting.md
```{{exec}}

Complete GitOps troubleshooting guide covering sync failures, drift detection, and best practices.
