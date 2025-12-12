<br>

### CRD validation mastered

**Key observations**

✅ OpenAPI v3 schemas enforce required fields, enums, patterns, and defaults at admission time.  
✅ Status subresources separate spec from status; patch status via `--subresource=status`.  
✅ `additionalProperties: false` blocks unknown fields; regex patterns catch malformed inputs.  
✅ Storage version is chosen per-CRD version list, even when applying older served versions.

**Production patterns**

Database CRD with validation, status, and scale:

```yaml
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
    shortNames: [db]
  scope: Namespaced
  versions:
  - name: v1
    served: true
    storage: true
    subresources:
      status: {}
      scale:
        specReplicasPath: .spec.replicas
        statusReplicasPath: .status.replicas
    schema:
      openAPIV3Schema:
        type: object
        required: [spec]
        properties:
          spec:
            type: object
            required: [engine, storageSize]
            properties:
              engine:
                type: string
                enum: [postgres, mysql, mongodb, redis]
              version:
                type: string
                pattern: '^[0-9]+\.[0-9]+(\.[0-9]+)?$'
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
                enum: [Pending, Creating, Ready, Failed, Deleting]
              replicas:
                type: integer
              readyReplicas:
                type: integer
```

**Cleanup**

```bash
kubectl delete database --all
kubectl delete crd databases.example.com
```{{exec}}

---

Next: Day 30 - Operator Reconciliation Loop Failures
