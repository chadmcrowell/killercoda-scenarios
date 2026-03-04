# Congratulations!

You've completed Day 86: **CRD Validation Failures — When Custom Resources Won't Apply**.

## What You Learned

- **OpenAPI v3 schema validation** is enforced by the Kubernetes API server at admission time — rejected resources are never written to etcd
- **Required fields** (`required: [...]`) cause a `Required value` error if any listed field is missing from the spec
- **Enum constraints** (`enum: [...]`) restrict a field to a fixed set of values — any other value returns an `Unsupported value` error with the allowed options listed
- **Numeric range constraints** (`minimum` / `maximum`) enforce floor and ceiling values on integer fields — violations return an `in body should be greater/less than or equal to` error
- **Pattern constraints** (`pattern: "^/"`) apply regex validation to string fields — violations return an `in body should match` error with the failing regex
- `kubectl explain <resource>.<field>` is the fastest way to read a CRD's field constraints without parsing raw YAML
- `kubectl get crd <name> -o jsonpath=...` lets you surgically extract specific validation rules from the schema

Keep building. See you tomorrow!

— Chad

*KubeSkills Daily — Fail Fast, Learn Faster*