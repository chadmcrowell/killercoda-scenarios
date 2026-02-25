Apply the updated `pod-data-processor.yaml`{{copy}} to the cluster and verify that the pod is scheduled and running.

```bash
kubectl apply -f pod-data-processor.yaml
```{{copy}}

Check the pod status and confirm it is in the `Running` state:

```bash
kubectl get pod data-processor -n production -o wide
```{{copy}}

The `NODE` column should show that the pod was scheduled to a node with the `disk=ssd`{{copy}} label.
