Using `kubectl` change the image used in the `source-ip-app` deployment to `registry.k8s.io/echoserver:1.3`.

<br>
<details><summary>Solution</summary>
<br>

```bash
# change the image used for the 'source-ip-app' deployment
kubectl set image deploy source-ip-app echoserver=registry.k8s.io/echoserver:1.4 echoserver=registry.k8s.io/echoserver:1.3

# quickly check the pod as they recreate. notice how the old version of the pod is deleted immediately, not waiting for the new pods to create.
kubectl get po

```{{exec}}


</details>