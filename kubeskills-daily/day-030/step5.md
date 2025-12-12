## Step 5: Manually reconcile (creating ConfigMap)

```bash
cat <<'CM' | kubectl apply -f -
apiVersion: v1
kind: ConfigMap
metadata:
  name: test-app-config
  ownerReferences:
  - apiVersion: apps.example.com/v1
    kind: WebApp
    name: test-app
    uid: $(kubectl get webapp test-app -o jsonpath='{.metadata.uid}')
    controller: true
data:
  message: "Hello World"
CM
```{{exec}}

Manual reconcile creates the ConfigMap the operator would own.
