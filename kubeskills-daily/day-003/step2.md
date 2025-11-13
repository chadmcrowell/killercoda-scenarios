## Step 2: Watch it get OOMKilled

```bash
kubectl get pods memory-hog -w
```{{exec}}

Sequence: Pending → ContainerCreating → Running → OOMKilled → CrashLoopBackOff. Hit `Ctrl+C` once you have seen at least one restart.
