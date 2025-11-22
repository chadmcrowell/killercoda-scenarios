## Step 4: Verify the discrepancy

```bash
kubectl exec secret-app -- sh -c 'echo $DB_PASSWORD'
```{{exec}}

```bash
kubectl exec secret-app -- cat /secrets/password
```{{exec}}

Environment variable is frozen at the old password; the volume shows the rotated value.
