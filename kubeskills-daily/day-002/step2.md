## Step 2: Watch the ordered creation

```bash
kubectl get pods -l app=nginx -w
```{{exec}}

You should see `web-0`, then `web-1`, then `web-2`. Each pod waits for its predecessor to reach Running before the controller continues. Keep this terminal open and start a second terminal for the next step.
