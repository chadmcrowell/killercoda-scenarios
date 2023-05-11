
Let's assume the role that we set for our new user and test access to Kubernetes!

In order to get our client certificate that we can use in our kubeconfig, we'll approve the CSR we submitted to the Kubernetes API

`k certificate approve carlton`

The output of the command `k get csr` should now have the condition "Approved,Issued":
```bash
$ k get csr
NAME        AGE     SIGNERNAME                                    REQUESTOR                  REQUESTEDDURATION   CONDITION
csr-hs6d2   16d     kubernetes.io/kube-apiserver-client-kubelet   system:node:controlplane   <none>              Approved,Issued
carlton     6m48s   kubernetes.io/kube-apiserver-client           kubernetes-admin           <none>              Approved,Issued
```

We can extract the client certificate out from the "k get csr" command, decode it and save it to a file named _carlton.crt_

`k get csr carlton -o jsonpath='{.status.certificate}' | base64 -d > carlton.crt`

Now that we have the key and certificate, we can set the credentials in our kubeconfig and embed the certs within

`k config set-credentials carlton --client-key=carlton.key --client-certificate=carlton.crt --embed-certs`

> 🔥TIP🔥: You can remove the `--embed-certs` and they will remain pointers to the key and certificate files. Try it out!

The output of `k config view` will now show _carlton_ as one of the users

Next, we'll set and use the context in which kubectl uses to access the Kubernetes API

`k config set-context carlton --user=carlton --cluster=kubernetes`

`k config use-context carlton`

Finally, we can test if our carlton user can get pods in the web namespace

`k -n web get po`