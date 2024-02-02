List the services on your Linux operating system that are associated with Kubernetes. Save the output to a file named services.csv.


<br>
<details><summary>Solution</summary>
<br>

```bash
# list unit files with systemctl and grep for 'kube'
sudo systemctl list-unit-files --type service --all | grep kube > services.csv
```{{exec}}

</details>