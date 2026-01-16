## Step 13: Test webhook deletion when cluster is broken

```bash
# If webhook blocks everything, you can't delete it normally!
# Use kubectl delete with --ignore-not-found and --force

# Simulate being unable to delete
echo "If webhooks block all operations, you must:"
echo "1. Use 'kubectl delete --raw' to bypass admission"
echo "2. Or directly edit etcd"
echo "3. Or use API server --disable-admission-plugins flag"
```{{exec}}

Know the emergency options when admission blocks deletion.
