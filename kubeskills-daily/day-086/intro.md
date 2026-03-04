# Day 86 — CRD Validation Failures: When Custom Resources Won't Apply

The platform team recently published a new `WebApp` CustomResourceDefinition (CRD) to standardize how teams describe their web applications in the cluster.

Three different application teams are blocked. Every time they try to `kubectl apply` their `WebApp` resources, the API server rejects them with validation errors. The resources never make it into the cluster, and nobody knows why.

In this scenario you will:

- Deploy the `WebApp` CRD and reproduce three distinct validation failures
- Read and interpret OpenAPI v3 schema validation errors returned by `kubectl`
- Inspect the CRD schema to understand the constraints behind each rejection
- Fix each broken resource and confirm all three apply successfully

Click **Start** to begin.
