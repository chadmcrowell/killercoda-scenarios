## Step 14: Test additional properties restriction

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
  - name: v1
    served: true
    storage: true
    schema:
      openAPIV3Schema:
        type: object
        properties:
          spec:
            type: object
            additionalProperties: false
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
apiVersion: example.com/v1
kind: Database
metadata:
  name: unknown-field
spec:
  engine: "postgres"
  storageSize: "10Gi"
  typo: "this-field-doesnt-exist"
CR
```{{exec}}

Should fail because additional spec properties are not allowed.
