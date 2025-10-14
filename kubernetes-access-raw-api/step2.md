
We can use the same method to extract the client certificate from the kubeconfig.

Use this command to extract the client certificate from the kubeconfig and save it to a file named _crt_

```bash
k config view --raw -o jsonpath='{.users[*].user.client-certificate-data}' | base64 -d > crt
```{{exec}}

Listing the contents of your current directory will now look like this:
```bash
$ ls
filesystem crt  key
```