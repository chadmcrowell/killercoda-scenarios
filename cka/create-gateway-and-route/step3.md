Deploy a simple web app in Kubernetes and a `ClusterIP` type service exposing the deployment on port `80` internally.

The name of the web app should be `web` and the image used should be `nginx`. Expose the container on port `80`.

The name of the service should also be web, and the service should be exposed on port `80` targeting port `80` in the pod as well.

Use ONLY the `kubectl` command line arguments to get the `web` deployment and service up and running.

<br>
<details><summary>Solution</summary>
<br>

```bash
# create a new deployment based on the `nginx` image and expose the container on port 80
kubectl create deployment web --image=nginx --port=80

# create the service by exposing the deployment `web` and set the service to be exposed on port 80 and target port 80 in the pod
kubectl expose deployment web --port=80 --target-port=80
```{{exec}}

</details>