Update the app by changing the image within the deployment. This will trigger a rollout, which means that the new version of the app will be deployed first before the old version of the app is destroyed.

Read more about updating a deployment in the official Kubernetes documentation: [kubernetes.io/docs](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#updating-a-deployment)

Read more about rollouts in the official Kubernetets documentation: [kubernetes.io/docs](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#rolling-back-a-deployment)

Update the deployment image from `chadmcrowell/nginx-for-k8s:v1` to `chadmcrowell/nginx-for-k8s:v2`

> **HINT:** The name of the container is used to target the image to update

<br>
<details><summary>Solution</summary>
<br>

Update the deployment image from `chadmcrowell/nginx-for-k8s:v1` to `chadmcrowell/nginx-for-k8s:v2`
```bash
k -n session283884 set image deploy scaler nginx-for-k8s=chadmcrowell/nginx-for-k8s:v2
```{{exec}}

View the new version of the app in a browser here: [chadmcrowell/nginx-for-k8s:v2]($HOST)

</details>