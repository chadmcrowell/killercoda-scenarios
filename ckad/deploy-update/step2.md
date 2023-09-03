To add replicas of your application running in pods, you can modify the deployment to add additional pods. This is called "scaling the deployment" because you are scaling the app to handle more requests from potential visitors to your app.

Scale the `scaler` deployment in the `SESSION-283884` namespace from 1 pod to 3 pods.

<br>
<details><summary>Solution</summary>
<br>

Scale the `scaler` deployment in the `session283884` namespace from 1 pod to 3 pods.
```bash
k -n session283884 scale deploy scaler --replicas 3
```{{exec}}

</details>