Expose the deployment `web` in the `session283884` namespace as a ClusterIP service on port 80.

<details><summary>Solution</summary>
<br>

```bash
kubectl -n session283884 expose deployment web --port=80 --target-port=80 --type=ClusterIP
```{{exec}}

```bash
kubectl -n session283884 get svc
```{{exec}}

</details>