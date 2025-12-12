## Step 12: Add status subresource

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
    singular: database
    shortNames:
    - db
  scope: Namespaced
  versions:
  - name: v1
    served: true
    storage: true
    subresources:
      status: {}
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
                enum: ["postgres", "mysql", "mongodb"]
              storageSize:
                type: string
                pattern: '^[0-9]+Gi$'
              replicas:
                type: integer
                minimum: 1
                maximum: 10
                default: 1
          status:
            type: object
            properties:
              phase:
                type: string
                enum: ["Pending", "Creating", "Ready", "Failed"]
              conditions:
                type: array
                items:
                  type: object
                  properties:
                    type:
                      type: string
                    status:
                      type: string
                    lastTransitionTime:
                      type: string
                      format: date-time
CRD
```{{exec}}

Status is now a separate subresource from spec.
