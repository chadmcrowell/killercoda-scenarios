## Step 1: Create CRD for operator testing

```bash
cat <<'CRD' | kubectl apply -f -
apiVersion: apiextensions.k8s.io/v1
kind: CustomResourceDefinition
metadata:
  name: webapps.apps.example.com
spec:
  group: apps.example.com
  names:
    kind: WebApp
    plural: webapps
    singular: webapp
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
            required: [message]
            properties:
              message:
                type: string
              replicas:
                type: integer
                default: 1
          status:
            type: object
            properties:
              configMapName:
                type: string
              phase:
                type: string
              observedGeneration:
                type: integer
CRD
```{{exec}}

Defines a WebApp CRD with status subresource to separate spec vs status updates.
