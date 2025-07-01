If you want to ensure that your apps running in Kubernetes stay running, even when the cluster is under heavy load, you can create a custom PriorityClass.

Assigning them a higher priority ensures they get scheduled first, and lower-prority pods get evicted before them if the node is full.

Use `kubectl` to create a new `PriorityClass` named `high-priority` with a value of `1000000`


> TIP: Use the [Kubernetes documentation](https://kubernetes.io/docs) or `kubectl create -h` for help


<br>
<details><summary>Solution</summary>
<br>

```bash
# create the priority class from the YAML file
kubectl create priorityclass high-priority --value=1000000
```

</details>