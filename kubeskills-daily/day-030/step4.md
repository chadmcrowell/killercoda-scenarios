## Step 4: Simulate operator behavior manually

```bash
cat <<'APP' | kubectl apply -f -
apiVersion: apps.example.com/v1
kind: WebApp
metadata:
  name: test-app
spec:
  message: "Hello World"
  replicas: 1
APP
```{{exec}}

Create a WebApp instance that the operator would reconcile.
