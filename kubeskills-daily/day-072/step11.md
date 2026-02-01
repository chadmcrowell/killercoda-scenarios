## Step 11: Test CRD version compatibility

```bash
# CRDs may need updates for new cluster versions
cat <<EOF | kubectl apply -f -
apiVersion: apiextensions.k8s.io/v1
kind: CustomResourceDefinition
metadata:
  name: testcrds.example.com
spec:
  group: example.com
  names:
    kind: TestCRD
    plural: testcrds
  scope: Namespaced
  versions:
  - name: v1beta1
    served: true
    storage: false
    deprecated: true
    deprecationWarning: "v1beta1 is deprecated, use v1"
    schema:
      openAPIV3Schema:
        type: object
        properties:
          spec:
            type: object
  - name: v1
    served: true
    storage: true
    schema:
      openAPIV3Schema:
        type: object
        properties:
          spec:
            type: object
EOF

# Create using old version
cat <<EOF | kubectl apply -f -
apiVersion: example.com/v1beta1
kind: TestCRD
metadata:
  name: test-old-version
spec: {}
EOF

kubectl get testcrds test-old-version
```{{exec}}

CRDs can mark versions as deprecated with warnings.
