## Step 7: Test CRD version compatibility

```bash
cat <<'EOF' | kubectl apply -f -
apiVersion: apiextensions.k8s.io/v1
kind: CustomResourceDefinition
metadata:
  name: crontabs.stable.example.com
spec:
  group: stable.example.com
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
              cronSpec:
                type: string
              image:
                type: string
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
            properties:
              cronSpec:
                type: string
  scope: Namespaced
  names:
    plural: crontabs
    singular: crontab
    kind: CronTab
EOF

cat <<'EOF' | kubectl apply -f -
apiVersion: stable.example.com/v1beta1
kind: CronTab
metadata:
  name: test-crontab
spec:
  cronSpec: "* * * * */5"
EOF
```{{exec}}

```bash
kubectl get crontabs.stable.example.com -o yaml
```{{exec}}

See deprecation warning in CRD versions.
