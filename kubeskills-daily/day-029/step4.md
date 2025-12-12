## Step 4: Delete CRD and recreate with strict validation

```bash
kubectl delete crd databases.example.com
kubectl delete database test-db 2>/dev/null

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
    singular: database
    shortNames:
    - db
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
            required:
            - engine
            - storageSize
            properties:
              engine:
                type: string
                enum:
                - postgres
                - mysql
                - mongodb
              storageSize:
                type: string
                pattern: '^[0-9]+Gi$'
              replicas:
                type: integer
                minimum: 1
                maximum: 10
                default: 1
              backup:
                type: object
                properties:
                  enabled:
                    type: boolean
                    default: false
                  schedule:
                    type: string
                    pattern: '^(\*|[0-9]{1,2}|\*/[0-9]+) (\*|[0-9]{1,2}|\*/[0-9]+) (\*|[0-9]{1,2}|\*/[0-9]+) (\*|[0-9]{1,2}|\*/[0-9]+) (\*|[0-9]|\*/[0-9]+)$'
CRD
```{{exec}}

Old CRD removed; new one enforces required fields, enums, patterns, and defaults.
