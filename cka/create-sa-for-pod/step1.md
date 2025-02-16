Create a new service account named ’secure-sa’ in the default namespace that will not automatically mount the service account token.

<br>
<details><summary>Solution</summary>
<br>

Create a YAML manifest file named `sa.yaml` that creates a new service account named `secure-sa` in the default namespace
```bash
# create the YAML for a service account named 'secure-sa' with the '--dry-run=client' option, saving it to a file named 'sa.yaml'
kubectl -n default create sa secure-sa --dry-run=client -o yaml > sa.yaml
```{{exec}}

Add the line `automountServiceAccountToken: false` to the YAML file `sa.yaml`
```bash
# add the automountServiceAccountToken: false to the end of the file 'sa.yaml'
echo "automountServiceAccountToken: false" >> sa.yaml
```{{exec}}

Create the service account with the correct `kubectl` command-line argument.
```bash
# create the service account from the file 'sa.yaml'
kubectl create -f sa.yaml

# list the newly created service account
kubectl -n default get sa
```{{exec}}


</details>