## Step 7: Create a secret from Docker config

If you already have a local Docker config, you can build a secret from it:

```bash
# kubectl create secret generic regcred \
#   --from-file=.dockerconfigjson=$HOME/.docker/config.json \
#   --type=kubernetes.io/dockerconfigjson
```

Simulate it manually with base64 content:

```bash
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Secret
metadata:
  name: manual-docker-secret
type: kubernetes.io/dockerconfigjson
data:
  .dockerconfigjson: eyJhdXRocyI6eyJwcml2YXRlLXJlZ2lzdHJ5LmV4YW1wbGUuY29tIjp7InVzZXJuYW1lIjoidGVzdCIsInBhc3N3b3JkIjoidGVzdCIsImF1dGgiOiJkR1Z6ZERwMFpYTjAifX19
EOF
```{{exec}}

```bash
kubectl get secret manual-docker-secret -o yaml
```{{exec}}
