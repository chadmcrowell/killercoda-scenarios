A deployment resource in Kubernetes contains a replicaSet and one or more pods.

You describe a desired state in a Deployment, and the Deployment Controller changes the actual state of the deployment and underlying replicaSet.

Read more about deployments in the official Kubernetes documentation: [https://kubernetes.io/docs](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/)

A replicaSet creates the underlying pods, ensuring that the desired number of identical pods are stable and running at all times.

Read more about ReplicaSets in the official Kubernetes documentation: [https://kubernetes.io/docs](https://kubernetes.io/docs/concepts/workloads/controllers/replicaset/)

Use `kubectl` command-line tool to create a deployment in the `SESSION-283884` namespace named "scaler" that uses the image `chadmcrowell/nginx-for-k8s:v1`.

Use `kubectl` to list the deployments, replicaSets, and pods in the `SESSION-283884` namespace.

<br>
<details><summary>Solution</summary>
<br>

Create a deployment named "scaler" that uses the image `chadmcrowell/nginx-for-k8s:v1`
```bash
k -n SESSION-283884 create deploy nginx-for-k8s --image chadmcrowell/nginx-for-k8s:v1
```{{exec}}

List the deployments in the default namespace
```bash
k -n SESSION-283884 get deploy,rs,po
```{{exec}}

> **OPTIONAL:** Create a NodePort service that exposes the "scaler" deployment
```bash
k expose deploy nginx-for-k8s --port 80 --type NodePort
```{{exec}}

</details>