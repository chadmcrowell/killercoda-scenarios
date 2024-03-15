Using only `kubectl`, change the image from `httpd` to `httpd:2.4.54`. List the events of the replicasets in the cluster.

<br>
<details><summary>Solution</summary>
<br>

```bash
# scale the apache deployment to 5 replicas
kubectl set image deploy apache httpd=httpd httpd=httpd:2.4.54

# list the events within the replicasets (new rs has been created)
kubectl describe rs


```{{exec}}


</details>