# Step 1 — Investigate the Problem

Three teams are blocked trying to deploy their `WebApp` resources. Your first task is to deploy the CRD, reproduce all three failures, and collect the exact error messages the API server returns.

## Deploy the WebApp CRD

The platform team's `WebApp` CRD enforces strict OpenAPI v3 schema validation. Deploy it now:

```bash
cat <<EOF | kubectl apply -f -
apiVersion: apiextensions.k8s.io/v1
kind: CustomResourceDefinition
metadata:
  name: webapps.kubeskills.io
spec:
  group: kubeskills.io
  names:
    kind: WebApp
    listKind: WebAppList
    plural: webapps
    singular: webapp
  scope: Namespaced
  versions:
  - name: v1alpha1
    served: true
    storage: true
    schema:
      openAPIV3Schema:
        type: object
        required: ["spec"]
        properties:
          spec:
            type: object
            required: ["image", "port", "tier"]
            properties:
              image:
                type: string
              replicas:
                type: integer
                minimum: 1
                maximum: 10
              port:
                type: integer
                minimum: 1
                maximum: 65535
              tier:
                type: string
                enum: ["frontend", "backend", "database"]
              healthPath:
                type: string
                pattern: "^/"
EOF
```{{exec}}

Confirm the CRD is ready:

```bash
kubectl get crd webapps.kubeskills.io
```{{exec}}

The `ESTABLISHED` column should read `True`. If it shows `False`, wait a few seconds and re-run.

## Reproduce the Failures

Now try to apply the three broken resources. **Each one will be rejected** — read the error output carefully. It contains all the information you need to fix the problem.

**Team Alpha's resource — a frontend web server:**

```bash
cat <<EOF | kubectl apply -f -
apiVersion: kubeskills.io/v1alpha1
kind: WebApp
metadata:
  name: webapp-alpha
  namespace: default
spec:
  image: nginx:1.25
  tier: frontend
EOF
```{{exec}}

Note the exact error message before moving on.

**Team Beta's resource — a microservice API:**

```bash
cat <<EOF | kubectl apply -f -
apiVersion: kubeskills.io/v1alpha1
kind: WebApp
metadata:
  name: webapp-beta
  namespace: default
spec:
  image: myapp:latest
  port: 8080
  tier: api
EOF
```{{exec}}

Note what field is rejected and why.

**Team Gamma's resource — a backend service with a health check:**

```bash
cat <<EOF | kubectl apply -f -
apiVersion: kubeskills.io/v1alpha1
kind: WebApp
metadata:
  name: webapp-gamma
  namespace: default
spec:
  image: myapp:2.0
  port: 8080
  tier: backend
  replicas: 0
  healthPath: "health"
EOF
```{{exec}}

This one returns multiple validation errors at once.

## Confirm Nothing Was Stored

All three rejections happen at admission time — before any resource is written to etcd:

```bash
kubectl get webapps
```{{exec}}

The list should be empty. The API server blocked all three resources before they could be stored.
