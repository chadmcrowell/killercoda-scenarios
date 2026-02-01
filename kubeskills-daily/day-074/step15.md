## Step 15: Comprehensive backup strategy

```bash
cat > /tmp/backup-strategy.md << 'EOF'
# Comprehensive Kubernetes Backup Strategy

## What to Backup

### 1. etcd (Cluster State)
- Contains all Kubernetes resources
- Does NOT include PV data
- Backup method: etcdctl snapshot

### 2. Persistent Volumes (Application Data)
- Database contents
- File uploads
- Application state
- Backup method: Volume snapshots or application-specific tools

### 3. Configuration
- Helm values
- GitOps repo
- CI/CD configs
- Backup method: Git repository

### 4. Secrets and Certificates
- TLS certificates
- API keys
- Passwords
- Backup method: Encrypted backup to secure storage

## Backup Strategy

### Frequency
- etcd: Hourly
- PV snapshots: Daily
- Application backups: Per RPO requirement

### Retention
- Daily backups: 7 days
- Weekly backups: 4 weeks
- Monthly backups: 12 months

### Storage
- Primary: Same region, different AZ
- Secondary: Cross-region
- Tertiary: Offline/tape for compliance

### Validation
- Daily: Automated restore test
- Weekly: Manual DR drill
- Monthly: Full recovery simulation

## Recovery Procedures

### RTO Targets
- Critical services: < 1 hour
- Standard services: < 4 hours
- Non-critical services: < 24 hours

### Recovery Steps
1. Restore etcd to new cluster
2. Restore PVs from snapshots
3. Restore application data from backups
4. Verify data integrity
5. Update DNS/load balancers
6. Test application functionality
EOF

cat /tmp/backup-strategy.md
```{{exec}}

Complete backup strategy documentation.
