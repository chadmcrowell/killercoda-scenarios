## Step 5: Compare legacy vs projected tokens

```bash
kubectl explain pod.spec.volumes.projected
```{{exec}}

```bash
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: projected-token
spec:
  containers:
  - name: app
    image: nginx
    volumeMounts:
    - name: token
      mountPath: /var/run/secrets/tokens
      readOnly: true
  volumes:
  - name: token
    projected:
      sources:
      - serviceAccountToken:
          path: api-token
          expirationSeconds: 3600  # 1 hour
          audience: api
EOF
```{{exec}}

```bash
kubectl exec projected-token -- cat /var/run/secrets/tokens/api-token
```{{exec}}

Decode to view claims and expiration:

```bash
TOKEN=$(kubectl exec projected-token -- cat /var/run/secrets/tokens/api-token)
echo $TOKEN | cut -d. -f2 | base64 -d 2>/dev/null | jq .
```{{exec}}
