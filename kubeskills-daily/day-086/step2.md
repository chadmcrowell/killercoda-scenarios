# Step 2 — Identify the Root Cause

You have three error messages. Now correlate each one with the CRD's schema to understand precisely why each resource was rejected.

## Inspect the Full CRD Schema

Fetch the raw schema from the CRD:

```bash
kubectl get crd webapps.kubeskills.io -o yaml
```{{exec}}

Scroll to `spec.versions[0].schema.openAPIV3Schema.properties.spec`. You'll find the validation rules for every field. Use `kubectl explain` for a cleaner view:

```bash
kubectl explain webapp.spec
```{{exec}}

Drill into individual fields to see their constraints:

```bash
kubectl explain webapp.spec.tier
kubectl explain webapp.spec.replicas
kubectl explain webapp.spec.port
kubectl explain webapp.spec.healthPath
```{{exec}}

## Root Cause — Team Alpha: Missing Required Field

The spec declares three required fields. Check which ones:

```bash
kubectl get crd webapps.kubeskills.io \
  -o jsonpath='{.spec.versions[0].schema.openAPIV3Schema.properties.spec.required[*]}{"\n"}'
```{{exec}}

Output: `image port tier`

Team Alpha's resource provided `image` and `tier` but omitted `port`. The API server returned:

```text
The WebApp "webapp-alpha" is invalid: spec.port: Required value
```

### Root Cause: `port` is listed in `required` but was not provided

## Root Cause — Team Beta: Invalid Enum Value

Check the allowed values for `tier`:

```bash
kubectl get crd webapps.kubeskills.io \
  -o jsonpath='{.spec.versions[0].schema.openAPIV3Schema.properties.spec.properties.tier.enum[*]}{"\n"}'
```{{exec}}

Output: `frontend backend database`

Team Beta used `tier: api`. That value does not exist in the enum. The API server returned:

```text
The WebApp "webapp-beta" is invalid:
  spec.tier: Unsupported value: "api": supported values: "frontend", "backend", "database"
```

### Root Cause: `tier: api` is not one of the three allowed enum values

## Root Cause — Team Gamma: Two Constraint Violations

Team Gamma's resource had two separate problems.

**Replicas below minimum:**

```bash
kubectl get crd webapps.kubeskills.io \
  -o jsonpath='{.spec.versions[0].schema.openAPIV3Schema.properties.spec.properties.replicas}{"\n"}'
```{{exec}}

Output: `{"maximum":10,"minimum":1,"type":"integer"}`

`replicas: 0` is below `minimum: 1`.

**healthPath fails pattern check:**

```bash
kubectl get crd webapps.kubeskills.io \
  -o jsonpath='{.spec.versions[0].schema.openAPIV3Schema.properties.spec.properties.healthPath}{"\n"}'
```{{exec}}

Output: `{"pattern":"^/","type":"string"}`

`healthPath: "health"` does not start with `/`, violating `pattern: "^/"`. The API server returned both errors together:

```text
The WebApp "webapp-gamma" is invalid:
  spec.replicas: Invalid value: 0: spec.replicas in body should be greater than or equal to 1
  spec.healthPath: Invalid value: "health": spec.healthPath in body should match '^/'
```

### Root Causes: `replicas` below minimum of 1, and `healthPath` missing the leading `/`

## Summary of Findings

| Resource       | Field        | Rule Violated                                       |
|----------------|--------------|-----------------------------------------------------|
| `webapp-alpha` | `port`       | Required field missing                              |
| `webapp-beta`  | `tier`       | Value not in enum (`frontend/backend/database`)     |
| `webapp-gamma` | `replicas`   | Below minimum (`minimum: 1`)                        |
| `webapp-gamma` | `healthPath` | Does not match pattern (`^/`)                       |
