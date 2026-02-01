## Step 8: Test feature gate changes

```bash
# Some features graduate from beta to GA and remove feature gates
echo "Feature gate changes between versions:"
echo "- EphemeralContainers: Beta in 1.23, GA in 1.25"
echo "- PodSecurity: Beta in 1.23, GA in 1.25"
echo "- CronJobTimeZone: Beta in 1.25, GA in 1.27"
echo ""
echo "After GA, feature gates are removed and feature is always on"
```{{exec}}

Feature gates removed when features reach GA status.
