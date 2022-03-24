
Now that we have a CSR, we can submit it to the Kubernetes API for approval.

First, let's store the value of the CSR in an environment variable named "REQUEST"

`export REQUEST=$(cat carlton.csr | base64 -w 0)`

Then, we can create a YAML manifest and sumbit it to the Kubernetes API. Insert the $REQUEST variable next to "request: " like so

```bash
cat <<EOF | kubectl apply -f -
apiVersion: certificates.k8s.io/v1
kind: CertificateSigningRequest
metadata:
  name: carlton
spec:
  groups:
  - system:authenticated
  request: $REQUEST
  signerName: kubernetes.io/kube-apiserver-client
  usages:
  - client auth
EOF
```

The output of the command `k get csr` should result in the following:
```bash
$ k get csr
NAME        AGE   SIGNERNAME                                    REQUESTOR                  REQUESTEDDURATION   CONDITION
csr-hs6d2   16d   kubernetes.io/kube-apiserver-client-kubelet   system:node:controlplane   <none>              Approved,Issued
carlton     8s    kubernetes.io/kube-apiserver-client           kubernetes-admin           <none>              Pending
```