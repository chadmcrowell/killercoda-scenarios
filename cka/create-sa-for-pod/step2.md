Create a pod that uses the ‘secure-sa’ service account. Make sure the token is not exposed to the pod.

Verify that the service account token is not mounted to the pod

<br>
<details><summary>Solution</summary>
<br>

```bash
# create the YAML for a pod named 'secure-pod' by using kubectl with the '--dry-run=client' option, output to YAML and saved to a file 'pod.yaml'
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: secure-pod
spec:
  serviceAccountName: secure-sa
  containers:
  - image: nginx
    name: secure-pod
EOF

# watch the 'secure-pod' pod waiting until the pod is running before proceeding
kubectl get po -w
```{{exec}}

Verify that the service account token is NOT mounted to the pod
```bash
kubectl exec secure-pod -- cat /var/run/secrets/kubernetes.io/serviceaccount/token
```{{exec}}

</details>