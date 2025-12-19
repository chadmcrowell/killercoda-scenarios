## Step 5: Describe pods to see the issue

```bash
kubectl describe pod -l app=service-a | grep -A 10 "Init Containers:"
kubectl describe pod -l app=service-b | grep -A 10 "Init Containers:"
```{{exec}}

Describe output shows init containers stuck on DNS/HTTP checks for the other service.
