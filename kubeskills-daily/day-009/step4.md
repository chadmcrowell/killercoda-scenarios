## Step 4: Verify environment variables are frozen

```bash
kubectl exec config-test -- env | grep -E "APP_MODE|LOG_LEVEL"
```{{exec}}

Env vars never change without a restart—they still show the original values.
