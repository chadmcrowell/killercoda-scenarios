## Step 9: Check for removed flags

```bash
# Check API server flags (conceptual)
echo "Removed flags in recent versions:"
echo "1.24: --service-account-api-audiences (replaced)"
echo "1.25: --pod-security-policy (PSP removed)"
echo "1.27: --enable-admission-plugins=PodSecurityPolicy (error if used)"
```{{exec}}

Component flags removed when features are deprecated.
