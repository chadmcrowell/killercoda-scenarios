## Step 11: Test API access with projected token

```bash
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: api-caller
spec:
  serviceAccountName: default
  containers:
  - name: app
    image: bitnami/kubectl:latest
    command:
    - sh
    - -c
    - |
      while true; do
        kubectl get pods
        sleep 30
      done
EOF
```{{exec}}

```bash
kubectl logs api-caller
```{{exec}}

Default ServiceAccount with projected token can call the API successfully.
