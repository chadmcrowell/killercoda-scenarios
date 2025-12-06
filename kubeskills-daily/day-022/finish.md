<br>

### Pull secrets demystified

**Key observations**

✅ ImagePullBackOff usually means auth or registry reachability issues.  
✅ Secrets must live in the same namespace as the pod using them.  
✅ ServiceAccounts can auto-attach imagePullSecrets to every pod.  
✅ Secret type matters: use kubernetes.io/dockerconfigjson for registry auth.  
✅ Multiple imagePullSecrets are tried sequentially until one works.

**Production patterns**

Create from Docker config:

```bash
kubectl create secret docker-registry regcred \
  --from-file=.dockerconfigjson=$HOME/.docker/config.json \
  --type=kubernetes.io/dockerconfigjson
```

ServiceAccount with multiple registries:

```yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: app-sa
imagePullSecrets:
- name: dockerhub-creds
- name: gcr-creds
- name: ecr-creds
```

Deployment with inline secret:

```yaml
apiVersion: apps/v1
kind: Deployment
spec:
  template:
    spec:
      imagePullSecrets:
      - name: private-registry-secret
      containers:
      - name: app
        image: private.registry/app:v1.0
        imagePullPolicy: IfNotPresent
```

Patch secret to include multiple registries:

```bash
kubectl create secret docker-registry multi-reg \
  --docker-server=registry1.example.com \
  --docker-username=user1 \
  --docker-password=pass1

# Add more registries by patching the docker config json (base64 encoded)
kubectl patch secret multi-reg -p '{"data":{".dockerconfigjson":"<base64-encoded-config>"}}'
```

**Cleanup**

```bash
kubectl delete pod private-image-fail wrong-secret-type ghcr-test auto-pull-secret multi-registry cross-namespace-fail image-debug pull-policy-test registry-timeout digest-image 2>/dev/null
kubectl delete secret broken-pull-secret correct-pull-secret manual-docker-secret ghcr-secret team-a-secret dockerhub-secret gcr-secret 2>/dev/null
kubectl delete serviceaccount image-puller 2>/dev/null
kubectl delete namespace team-a team-b 2>/dev/null
```{{exec}}

---

Next: Day 23 - CNI Plugin Failures and Pod Networking
