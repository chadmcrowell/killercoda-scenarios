## Step 14: Drift prevention strategies

```bash
cat > /tmp/drift-prevention.md << 'OUTER'
# Configuration Drift Prevention

## Root Causes
1. Manual changes (kubectl edit/patch/set)
2. Emergency hotfixes skipping CI/CD
3. Environment-specific changes left in place
4. Lack of enforcement and detection

## Prevention Strategies

### 1. GitOps with Auto-Sync
- ArgoCD/Flux auto-revert manual changes
- selfHeal: true reverts drift automatically
- prune: true removes untracked resources

### 2. Admission Control
- Webhook validates changes come from CI/CD
- OPA Gatekeeper blocks manual updates
- Require CI annotation on all changes

### 3. Drift Detection
- Automated scanning every 30 minutes
- Compare cluster state to Git
- Alert on any differences

### 4. Read-Only Developer Access
- Developers: get, list, watch only
- Only CI/CD service accounts can write
- Break-glass procedure for emergencies

### 5. Immutable Infrastructure
- Use image digests, not tags
- Recreate instead of update
- No in-place modifications

### 6. Configuration as Code
- Store everything in Git
- Use Kustomize overlays per environment
- No manual configuration

### 7. Change Management
- Require pull requests for all changes
- Manual approval for production
- Automated validation in CI

### 8. Audit Logging
- Enable Kubernetes audit policy
- Track all update/patch operations
- Alert on non-CI user modifications

## Red Flags
- "I'll just kubectl edit this quickly"
- "Let me hotfix prod, I'll update Git later"
- "Staging is different, but it's fine"
- "We don't have time for a PR"
- "Nobody knows what's actually running"
OUTER

cat /tmp/drift-prevention.md
```{{exec}}

Complete drift prevention guide covering GitOps enforcement, admission control, RBAC restrictions, and change management.
