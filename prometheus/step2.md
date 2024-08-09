Add the `enforce=restricted` policy to the newly created namespace `my-namespace`, pinning the restricted policy version to v1.30.


<br>
<details><summary>Solution</summary>
<br>

```bash
kubectl label --overwrite ns my-namespace \
  pod-security.kubernetes.io/enforce=restricted \
  pod-security.kubernetes.io/enforce-version=v1.30
```{{exec}}


</details>