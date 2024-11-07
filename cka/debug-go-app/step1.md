You will see a deployment and a service running inside the default namespace.

```bash
k get deploy,svc
```{{exec}}

Using `curl`, try to access the Go application by it's service FQDN.


<br>
<details><summary>Solution</summary>
<br>

```bash
# use curl to access the `goapp-service` service by it's DNS name
curl http://goapp-service.default.svc.cluster.local:8080

```


</details>