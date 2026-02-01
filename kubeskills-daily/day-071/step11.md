## Step 11: Test CRD with conversion webhook

```bash
# CRD with multiple versions
cat <<EOF | kubectl apply -f -
apiVersion: apiextensions.k8s.io/v1
kind: CustomResourceDefinition
metadata:
  name: multiversions.example.com
spec:
  group: example.com
  names:
    kind: MultiVersion
    plural: multiversions
  scope: Namespaced
  versions:
  - name: v1
    served: true
    storage: false
    schema:
      openAPIV3Schema:
        type: object
        properties:
          spec:
            type: object
            properties:
              oldField:
                type: string
  - name: v2
    served: true
    storage: true
    schema:
      openAPIV3Schema:
        type: object
        properties:
          spec:
            type: object
            properties:
              newField:
                type: string
  conversion:
    strategy: Webhook
    webhook:
      clientConfig:
        service:
          name: conversion-webhook
          namespace: default
          path: /convert
      conversionReviewVersions: ["v1"]
EOF

# Webhook doesn't exist - conversions fail
cat <<EOF | kubectl apply -f -
apiVersion: example.com/v1
kind: MultiVersion
metadata:
  name: test-v1
spec:
  oldField: "value"
EOF

sleep 5
kubectl get multiversion test-v1 2>&1 || echo "Conversion failed - webhook not available"
```{{exec}}

CRD with conversion webhook fails when webhook service is missing.
