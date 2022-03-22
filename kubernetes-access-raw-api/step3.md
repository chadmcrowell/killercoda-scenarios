
Finally, we'll need the address of the API server. Use this command to save the API server address in an environment variable named _SERVER_:  
`SERVER=$(k config view -o jsonpath='{.clusters[*].cluster.server}')` 

Now that we have the Kubernetes API server address, a private key and client certificate, we can curl the API using the command  
`curl $SERVER --cacert /etc/kubernetes/pki/ca.crt --cert crt --key key`