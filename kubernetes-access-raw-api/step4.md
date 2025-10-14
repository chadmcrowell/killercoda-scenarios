
Now that you've authenticated with the Kubernetes API, try accessing particular resources within the API.

For example, we can use this command to list the pods running in Kubernetes  

```bash
curl $SERVER/api/v1/pods --cacert /etc/kubernetes/pki/ca.crt --cert crt --key key
```{{exec}}
