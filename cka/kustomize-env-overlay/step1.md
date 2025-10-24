Create two Kustomize overlays (`dev` and `prod`) from a base deployment.

<details><summary>Solution</summary>
<br>

directory layout:
```bash
my-kustomize-project/
├── base/
│   ├── deployment.yaml
│   ├── service.yaml
│   └── kustomization.yaml
├── overlays/
│   ├── dev/
│   │   ├── kustomization.yaml
│   │   └── patch-deployment.yaml
│   └── prod/
│       ├── kustomization.yaml
│       └── patch-deployment.yaml

```

`base/kustomization.yaml`
```yaml
resources:
  - deployment.yaml
  - service.yaml

```

`overlays/dev/kustomization.yaml`
```yaml
resources:
  - ../../base

patchesStrategicMerge:
  - patch-deployment.yaml

namePrefix: dev-
namespace: dev

```

`overlays/prod/kustomization.yaml`
```yaml
resources:
  - ../../base

patchesStrategicMerge:
  - patch-deployment.yaml

namePrefix: prod-
namespace: prod

```

`overlays/prod/patch-deployment.yaml`
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: my-app
spec:
  replicas: 3
  template:
    spec:
      containers:
        - name: my-app
          image: my-app:prod
          env:
            - name: ENV
              value: "production"

```

Apply with Kustomize:
```yaml
# Apply dev
kubectl apply -k overlays/dev/

# Apply prod
kubectl apply -k overlays/prod/

```

</details>