## Step 9: Use multiple registry secrets

```bash
kubectl create secret docker-registry dockerhub-secret \
  --docker-server=index.docker.io \
  --docker-username=user \
  --docker-password=pass \
  --docker-email=user@example.com
kubectl create secret docker-registry gcr-secret \
  --docker-server=gcr.io \
  --docker-username=user \
  --docker-password=pass \
  --docker-email=user@example.com
```{{exec}}

```bash
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: multi-registry
spec:
  imagePullSecrets:
  - name: dockerhub-secret
  - name: ghcr-secret
  - name: gcr-secret
  containers:
  - name: app1
    image: private-repo/image1:latest
  - name: app2
    image: ghcr.io/org/image2:latest
  - name: app3
    image: gcr.io/project/image3:latest
EOF
```{{exec}}

Kubernetes tries each pull secret in order until one works for each image.
