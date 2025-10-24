Validate that a Kubernetes service routes traffic correctly between pods.

1. Deploy an `nginx` backend and a testing pod.
2. Expose the backend through a ClusterIP service.
3. Use the testing pod to confirm service resolution and HTTP connectivity.

<details><summary>Solution</summary>
<br>

```bash
kubectl create namespace svc-test
```{{exec}}

```bash
kubectl -n svc-test create deploy web --image=nginx:1.25 --replicas=2 --port=80
```{{exec}}

```bash
kubectl -n svc-test expose deploy web --name=web --port=80 --target-port=80
```{{exec}}

```bash
kubectl -n svc-test run tester --image=busybox:1.36 --restart=Never --command -- sh -c "sleep 3600"
```{{exec}}

```bash
kubectl -n svc-test exec tester -- nslookup web
```{{exec}}

```bash
kubectl -n svc-test exec tester -- wget -qO- http://web
```{{exec}}

```bash
kubectl -n svc-test get endpoints web
```{{exec}}

</details>
