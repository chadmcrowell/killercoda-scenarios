Create a deployment named "mysql" that uses the image "mysql:8". 

View the deployment and pod, and find out why it's not running

Fix the deployment in order to get the pod in a running state.

<br>
<details><summary>Solution</summary>
<br>

```bash
k create deploy mysql --image mysql:8
```{{exec}}

```bash
# in deployment, add
env:
  - name: MY_SQL_PASSWORD
  value: "password"
```{{exec}}

</details>