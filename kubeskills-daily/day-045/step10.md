## Step 10: Debug with profile

```bash
kubectl debug minimal-app -it --profile=general --image=ubuntu
```{{exec}}

Profiles (general/baseline/restricted/netadmin/sysadmin) set default security contexts for debugging.
