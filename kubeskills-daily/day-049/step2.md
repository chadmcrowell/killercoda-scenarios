## Step 2: Install Velero in cluster (filesystem target)

```bash
velero install \
  --provider aws \
  --plugins velero/velero-plugin-for-aws:v1.8.0 \
  --bucket velero-backups \
  --secret-file /dev/null \
  --use-volume-snapshots=false \
  --backup-location-config region=minio,s3ForcePathStyle="true",s3Url=http://minio.velero.svc:9000 \
  --use-node-agent \
  --uploader-type=restic

kubectl wait --for=condition=Ready pods --all -n velero --timeout=120s
```{{exec}}|skip{{sandbox}}

Installs Velero with restic/uploader and no volume snapshots (uses MinIO endpoint).
