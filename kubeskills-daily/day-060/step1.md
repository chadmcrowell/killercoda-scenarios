## Step 1: Create CRD for custom resource

```bash
cat <<EOF | kubectl apply -f -
apiVersion: apiextensions.k8s.io/v1
kind: CustomResourceDefinition
metadata:
  name: apptasks.example.com
spec:
  group: example.com
  names:
    kind: AppTask
    plural: apptasks
    singular: apptask
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
            properties:
              replicas:
                type: integer
                minimum: 1
                maximum: 10
              image:
                type: string
          status:
            type: object
            properties:
              phase:
                type: string
              observedGeneration:
                type: integer
    subresources:
      status: {}
EOF
```{{exec}}

Define a custom resource with status so a controller can report reconciliation progress.
