Create a service named `apache-svc` from the `apache` deployment created in the previous step.

<br>
<details><summary>Solution</summary>
<br>

```bash
# create a service from the apache deployment
kubectl expose deploy apache --name apache-svc
```{{exec}}

</details>