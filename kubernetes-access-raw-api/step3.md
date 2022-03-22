
Finally, we'll need the address of the API server. Use the command `SERVER=$(k config view -o jsonpath='{.clusters[*].cluster.server}')` to save the API server address in an environment variable named _SERVER_.

Now that we have the Kubernetes API server address, a private key and client certificate, we can curl the API using the command  
`curl $SERVER --cacert /etc/kubernetes/pki/ca.crt --cert crt --key key`