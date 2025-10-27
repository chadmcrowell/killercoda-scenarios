
### Goal

Create a namespace named `psa-restricted` that strictly enforces the Kubernetes Pod Security Standards (PSS) at the `restricted` level.

Try to complete the tasks on your own before opening the solution.

<details>
<summary>Show solution</summary>

### Tasks

1. **Create the namespace.**

```bash
kubectl create namespace psa-restricted
```{{exec}}

2. **Label the namespace with Pod Security Admission (PSA) settings.**  

The `enforce` label blocks non-compliant pods, while `warn` and `audit` help surface issues during testing.

```bash
kubectl label namespace psa-restricted \
    pod-security.kubernetes.io/enforce=restricted \
    pod-security.kubernetes.io/enforce-version=latest \
    pod-security.kubernetes.io/warn=restricted \
    pod-security.kubernetes.io/audit=restricted
```{{exec}}

3. **(Optional) Scope your current context to the new namespace** so subsequent commands run there automatically.

```bash
kubectl config set-context --current --namespace=psa-restricted
```{{exec}}

4. **Verify the labels** to confirm the namespace is ready for the next steps.

```bash
kubectl get namespace psa-restricted --show-labels
```{{exec}}

</details>
