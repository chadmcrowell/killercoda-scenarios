Create a pod that uses the previously created ‘secure-sa’ service account. Make sure the token is not exposed to the pod!

Verify that the service account token is not mounted to the pod

<br>
<details><summary>Solution</summary>
<br>

Create the YAML for a pod named `secure-pod` specifying the service account name
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


```{{exec}}

List the pods in the default namespace, waiting for the pod to appear as running
```bash
# list the pods in the default namespace and wait until the pod is running
kubectl -n default get po
```{{exec}}

Verify that the service account token is NOT mounted to the pod
```bash
# get a shell to the pod and output the token (if mounted)
kubectl exec secure-pod -- cat /var/run/secrets/kubernetes.io/serviceaccount/token
```{{exec}}

You should get the following, indidcating that the service account token was not mounted
```plaintext
controlplane $ kubectl exec secure-pod -- cat /var/run/secrets/kubernetes.io/serviceaccount/token
cat: /var/run/secrets/kubernetes.io/serviceaccount/token: No such file or directory
command terminated with exit code 1
```

</details>