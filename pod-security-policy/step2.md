
### Goal

Create a pod named `non-compliant` using the image `nginx:1.25` that should not run because it violates the `restricted` profile.

Try to achieve this result yourself, then reveal the steps if needed.

<details>
<summary>Show solution</summary>

### Tasks

1. **Create a manifest for an intentionally insecure pod.**

```bash
cat <<'EOF' > non-compliant-pod.yaml
apiVersion: v1
kind: Pod
metadata:
    name: non-compliant
    namespace: psa-restricted
spec:
    containers:
    - name: web
    image: nginx:1.25
    securityContext:
        privileged: true
EOF
```

2. **Attempt to deploy the pod into the restricted namespace.**

```bash
kubectl apply -f non-compliant-pod.yaml
```

PSA should reject the request with a `restricted` violation message because the container asks for `privileged: true`.

3. **Review the admission warnings (optional).**

```bash
kubectl get events -n psa-restricted --field-selector involvedObject.name=bad-nginx
```

The event log records that the pod was denied, which confirms the enforcement policy is active.

</details>
