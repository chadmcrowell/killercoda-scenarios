## Step 2: Try to create a pod (hangs!)

```bash
time kubectl run test-pod --image=nginx
```{{exec}}

Creation should take ~10 seconds before failing with a webhook connection error.
