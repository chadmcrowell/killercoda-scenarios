Create the pod from the YAML file `pod-tolerate.yaml`. Verify that it has been scheduled to the control plane node.

<br>
<details><summary>Solution</summary>
<br>

```bash
# create a pod that has a toleration for the taint that has been applied to the controlplane node
kubectl create -f pod-tolerate.yaml

# verify that the pod has been scheduled to the control plane and is running
kubectl get po -o wide

```{{exec}}


</details>