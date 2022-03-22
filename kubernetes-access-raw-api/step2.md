
We can use the same method to extract the client certificate from the kubeconfig.

Use the command `k config view --raw -o jsonpath='{.users[*].user.client-certificate-data}' | base64 -d > crt` to extract the client certificate from the kubeconfig and save it to a file named _crt_

Listing the contents of your current directory will now look like this:
```bash
controlplane $ ls
crt  key  snap
```