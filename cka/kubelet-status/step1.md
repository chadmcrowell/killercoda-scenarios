List the status of the kubelet service running on the Kubernetes node and output the result to a file named kubelet-status.txt saving the file in the /tmp directory.

<br>
<details><summary>Solution</summary>
<br>

```bash
# get the status of kubelet using systemctl and save to '/tmp/kubelet-status.txt'
sudo systemctl status kubelet > /tmp/kubelet-status.txt
```{{exec}}

</details>