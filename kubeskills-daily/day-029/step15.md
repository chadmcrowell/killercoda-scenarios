## Step 15: Test multiple versions

```bash
kubectl delete crd databases.example.com

cat <<'CRD' | kubectl apply -f -
apiVersion: apiextensions.k8s.io/v1
kind: CustomResourceDefinition
metadata:
  name: databases.example.com
spec:
  group: example.com
  names:
    kind: Database
    plural: databases
  scope: Namespaced
  versions:
  - name: v1alpha1
    served: true
    storage: false
    schema:
      openAPIV3Schema:
        type: object
        properties:
          spec:
            type: object
            properties:
              type:
                type: string
              size:
                type: string
  - name: v1
    served: true
    storage: true
    schema:
      openAPIV3Schema:
        type: object
        properties:
          spec:
            type: object
            required: ["engine", "storageSize"]
            properties:
              engine:
                type: string
              storageSize:
                type: string
CRD
```{{exec}}

```bash
cat <<'CR' | kubectl apply -f -
apiVersion: example.com/v1alpha1
kind: Database
metadata:
  name: alpha-version
spec:
  type: "postgres"
  size: "10Gi"
CR
```{{exec}}

```bash
kubectl get database alpha-version -o yaml | grep apiVersion
```{{exec}}

Even though created via v1alpha1, the stored version should be v1 (storage version).
