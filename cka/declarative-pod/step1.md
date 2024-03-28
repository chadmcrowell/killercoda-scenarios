Using kubectl, create a YAML file for a pod named `pod` that uses the image `nginx`. Save the YAML file as chap1-pod.yaml. 

> HINT: Use the `kubectl run` command and `--dry-run` to accomplish this task

<br>
<details><summary>Solution</summary>
<br>

```bash
# use kubectl to create a dry run of a pod, output to YAML, and save it to the file 'chap1-pod.yaml' 
kubectl run pod --image nginx --dry-run=client -o yaml > chap1-pod.yaml

# create the pod from YAML
kubectl create -f chap1-pod.yaml
```{{exec}}

</details>