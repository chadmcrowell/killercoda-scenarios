## Step 9: Test point-in-time recovery

```bash
# Create data at T0
kubectl exec -n backup-test postgres-0 -- psql -U postgres -c "
  TRUNCATE users;
  INSERT INTO users (name) VALUES ('T0-User');
"

# Backup at T1
kubectl exec -n backup-test postgres-0 -- pg_dump -U postgres > /tmp/db-backup-t1.sql

# Create more data at T2
kubectl exec -n backup-test postgres-0 -- psql -U postgres -c "
  INSERT INTO users (name) VALUES ('T2-User');
"

# Backup at T3
kubectl exec -n backup-test postgres-0 -- pg_dump -U postgres > /tmp/db-backup-t3.sql

# Restore to T1 (lose T2 data)
kubectl exec -n backup-test postgres-0 -- psql -U postgres -c "DROP TABLE users;"
kubectl exec -i -n backup-test postgres-0 -- psql -U postgres < /tmp/db-backup-t1.sql

# Check data
kubectl exec -n backup-test postgres-0 -- psql -U postgres -c "SELECT * FROM users;"
```{{exec}}

Point-in-time recovery shows only T0-User, T2 data lost.
