Use the declarative syntax to create a pod from a YAML file in Kubernetes. Save the YAML file as chap1-pod.yaml. Use the `kubectl run` command to create the pod.

<br>
<details><summary>Solution</summary>
<br>

```bash
# use kubectl to create a dry run of a pod, output to YAML, and save it to the file 'chap1-pod.yaml' 
kubectl run pod --image nginx --dry-run=client -o yaml > chap1-pod.yaml
```{{exec}}

</details>