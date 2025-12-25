## Step 13: Find and clean orphaned PVCs

```bash
kubectl get pvc -o custom-columns=NAME:.metadata.name,STATUS:.status.phase,PV:.spec.volumeName

kubectl get pvc -o json | jq -r '.items[] | select(.metadata.ownerReferences == null) | .metadata.name'

cat > /tmp/find-orphan-pvcs.sh << 'EOF'
#!/bin/bash
for pvc in $(kubectl get pvc -o name); do
  pvc_name=${pvc#*/}
  if ! kubectl get pods -o json | jq -e ".items[] | .spec.volumes[]? | .persistentVolumeClaim? | select(.claimName == \"$pvc_name\")" > /dev/null 2>&1; then
    echo "Orphaned: $pvc_name"
  fi
done
EOF

chmod +x /tmp/find-orphan-pvcs.sh
/tmp/find-orphan-pvcs.sh
```{{exec}}

Identify PVCs not referenced by any pods.
