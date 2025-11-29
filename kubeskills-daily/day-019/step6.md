## Step 6: Test token rotation

```bash
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: rotating-token
spec:
  containers:
  - name: app
    image: busybox
    command:
    - sh
    - -c
    - while true; do echo "Token at $(date):"; cat /var/run/secrets/tokens/token | cut -d. -f2 | base64 -d 2>/dev/null; sleep 300; done
    volumeMounts:
    - name: token
      mountPath: /var/run/secrets/tokens
  volumes:
  - name: token
    projected:
      sources:
      - serviceAccountToken:
          path: token
          expirationSeconds: 600  # 10 minutes
EOF
```{{exec}}

```bash
kubectl logs rotating-token -f
```{{exec}}

Kubelet refreshes the token before it expires—watch payload timestamps change.
