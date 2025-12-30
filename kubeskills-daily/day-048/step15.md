## Step 15: Document upgrade path

```bash
cat > /tmp/upgrade-plan.md << 'EOF'
# Kubernetes Upgrade Plan

## Pre-Upgrade Checklist
- [ ] Backup etcd
- [ ] Check deprecated APIs
- [ ] Update CRDs to new versions
- [ ] Test upgrade in staging
- [ ] Review changelog for breaking changes
- [ ] Update client tools (kubectl, helm, etc.)

## Version Compatibility Rules
- Control plane can be 1 minor version ahead of nodes
- Nodes cannot be newer than control plane
- kubectl can be ±1 minor version from API server
- Upgrade one minor version at a time (1.26 → 1.27 → 1.28)

## Upgrade Order
1. Backup cluster state (etcd, configs)
2. Upgrade control plane components:
   - kube-apiserver
   - kube-controller-manager
   - kube-scheduler
3. Upgrade cluster add-ons (CNI, DNS, etc.)
4. Upgrade nodes (drain → upgrade → uncordon)
5. Verify cluster health
6. Update client tools

## Post-Upgrade Verification
- [ ] All nodes Ready
- [ ] All system pods Running
- [ ] API server responding
- [ ] Workloads functioning
- [ ] No deprecated API warnings
- [ ] Check logs for errors

## Rollback Plan
- Keep etcd backup for 24 hours
- Document current versions
- Test rollback procedure in staging
- Know the rollback limitations (some changes irreversible)
EOF

cat /tmp/upgrade-plan.md
```{{exec}}

A lightweight upgrade plan for reference.
