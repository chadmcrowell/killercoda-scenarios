## Step 5: Projected volume with explicit items

```bash
kubectl delete pod secret-app
```{{exec}}

```bash
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: projected-secret
spec:
  containers:
  - name: app
    image: busybox
    command: ['sh', '-c', 'while true; do echo "Password:"; cat /secrets/db-pass; echo ""; sleep 10; done']
    volumeMounts:
    - name: secret-volume
      mountPath: /secrets
  volumes:
  - name: secret-volume
    projected:
      sources:
      - secret:
          name: db-credentials
          items:
          - key: password
            path: db-pass
            mode: 0400  # Read-only for owner
EOF
```{{exec}}

```bash
kubectl logs projected-secret -f &
```{{exec}}

```bash
kubectl patch secret db-credentials -p '{"stringData":{"password":"rotated789"}}'
```{{exec}}

```bash
kubectl exec projected-secret -- cat /secrets/db-pass
```{{exec}}

Projected volumes track updates after the sync delay; expect the file to change to `rotated789`.
