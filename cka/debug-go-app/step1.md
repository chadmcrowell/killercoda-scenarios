Check on the status of the deployment `goapp-deployment`. 

<br>
<details><summary>Solution</summary>
<br>

The logs show that the PORT environment variable is not set.
```bash
# get the deployment and pod
k get deploy,po

```


</details>