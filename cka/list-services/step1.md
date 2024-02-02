Using the kubectl CLI tool, list all the services created in your Kubernetes cluster, across all namespaces. Save the output of the command to a file named “all-k8s-services.txt”.

<br>
<details><summary>Solution</summary>
<br>

```bash
# list the services with the '-A' for all namespaces and save to the file 'all-k8s-services.txt'
kubectl get svc -A > all-k8s-services.txt
```{{exec}}

</details>