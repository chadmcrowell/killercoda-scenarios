Using the kubectl CLI tool, get the output of the pods running in the kube-system namespace and show the pod IP addresses. Save the output of the command to a file named “pod-ip-output.txt”.

<br>
<details><summary>Solution</summary>
<br>

```bash
# list the pods in the kube-system namespace and save the output to a file named 'pod-ip-output.txt'
kubectl -n kube-system get po -o wide > pod-ip-output.txt
```{{exec}}

</details>