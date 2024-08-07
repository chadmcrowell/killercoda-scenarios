StatefulSet supports both non-cascading and cascading deletion. In a non-cascading delete, the StatefulSet's Pods are not deleted when the StatefulSet is deleted. In a cascading delete, both the StatefulSet and its Pods are deleted.

Use `kubectl delete` to delete the StatefulSet. Make sure to supply the `--cascade=orphan` parameter to the command. This parameter tells Kubernetes to only delete the StatefulSet, and to not delete any of its Pods.

List the pods, and you should see that they are still running.

<br>
<details><summary>Solution</summary>
<br>

```bash
kubectl delete statefulset web --cascade=orphan

kubectl get pods -l app=nginx
```{{exec}}





</details>