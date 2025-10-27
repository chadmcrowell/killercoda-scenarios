
### Goal

Deploy a pod named `compliant-pod` in the `psa-restricted` namespace that complies with the `restricted` profile so it passed admission control.

Work through the deployment on your own, then expand below for the full solution.

<details>
<summary>Show solution</summary>

### Tasks

1. **Write a restricted-friendly pod manifest.**

```bash
cat <<'EOF' > compliant-pod.yaml
apiVersion: v1
kind: Pod
metadata:
  name: compliant-pod
  namespace: psa-restricted
spec:
  securityContext:
    runAsNonRoot: true
    seccompProfile:
      type: RuntimeDefault
  containers:
    - name: web
      image: nginx:1.25
      ports:
        - containerPort: 80
      securityContext:
        allowPrivilegeEscalation: false
        capabilities:
        drop:
          - ALL
EOF
```{{exec}}

2. **Apply the manifest to the namespace enforced by PSA.**

```bash
kubectl apply -f compliant-pod.yaml
```{{exec}}

3. **Verify that the pod runs and passes admission.**

```bash
kubectl get pods -n psa-restricted
```{{exec}}

The pod should move to the `Running` phase, demonstrating that it satisfies the `restricted` policy.

</details>
