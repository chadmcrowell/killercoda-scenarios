View the file in your home directory named `pod.yaml`. Apply the correct toleration to this pod manifest in order for it to successfully get scheduled to node01.

After modifying the `pod.yaml` file, run the command `k apply -f ~/pod.yaml`{{exec}} to create the pod.

Then, run the command `k get po -o wide`{{exec}} to verify that the pod status is `Running`

**HINT:** The key, value, and effect have to match the taint

<br>
<details><summary>Solution</summary>
<br>

The final `pod.yaml` file should look like this
```yaml
apiVersion: v1
kind: Pod
metadata:
  labels:
    run: nginx
  name: nginx
spec:
  tolerations:
  - key: "dedicated"
    value: "special-user"
    effect: "NoSchedule"
  containers:
  - image: nginx
    name: nginx
```


</details>
