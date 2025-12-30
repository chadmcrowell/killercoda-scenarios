## Step 8: Monitor certificate renewal

```bash
watch -n 5 "kubectl get certificate short-lived-cert -o jsonpath='{.status.conditions[0].message}'"
```{{exec}}

Watch renewal status messages.
