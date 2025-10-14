
Accessing the Kubernetes API requires authentication. Using `kubectl`, we authenticate with the kubeconfig located in `.kube/config`.

We can extract the authentiction data from this kubeconfig and use it to access the Kubernetes API with curl.

First, we'll extract the private key and save it to a file named _key_ with this command

```bash
k config view --raw -o jsonpath='{.users[*].user.client-key-data}' | base64 -d > key
```{{exec}}

Listing the contents of your current directory will now look like this:
```bash
$ ls
filesystem  key
```
