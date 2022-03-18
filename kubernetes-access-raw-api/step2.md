
To view the secret of the default service account, list the YAML via the command `kubectl get sa default -o yaml -n kube-system`. 

Once you have the secret name, you can output the yaml to view the token with the command `kubectl get secret default-token-fzls7 -n kube-system -o yaml`

> default-token-fzls7 is the name of my secret, but yours will be different

Copy the token to your clipboard