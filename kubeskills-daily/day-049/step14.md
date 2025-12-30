## Step 14: Test backup exclusions

```bash
velero backup create exclude-test \
  --include-namespaces backup-test \
  --exclude-resources pods,replicasets \
  --wait

velero backup describe exclude-test
```{{exec}}

Excludes workloads while backing up namespace-scoped resources.
