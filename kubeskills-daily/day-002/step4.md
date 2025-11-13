## Step 4: Check StatefulSet controller events

```bash
kubectl describe statefulset web | tail -20
```{{exec}}

Look for messages like `Waiting for web-1 to be Running`. Those events prove that ordered updates enforce strict predecessors.
