1. Run the command to list the pods and their labels

2. Run the command to list the pods by their label

3. Run a command to get the pod IP addresses

4. Run the command to view which port the pods are exposed on.

5. Use this command to run busybox pod and get a shell to it for troubleshooting:
```
kubectl run -it --rm --restart=Never busybox --image=gcr.io/google-containers/busybox sh
```{{exec}}

- From a shell to a pod, see if the pods are listening on the correct port.

You should get something similar to the following output:
```bash
hostnames-54b9d67f64-khfsj
hostnames-54b9d67f64-zq79d
hostnames-54b9d67f64-trl7r
```

<br>
<details><summary>Solution</summary>
<br>

```plain
# get the pod labels
kubectl get po --show-labels
```{{exec}}

```plain
# list the pods by their label
kubectl get pods -l app=hostnames
```{{exec}}

```plain
# get the pod IPs
kubectl get po -o wide
```{{exec}}

```plain
for ep in 192.168.0.8:9376 192.168.0.7:9376 192.168.0.9:9376; do
    wget -qO- $ep
done
```{{copy}}

</details>
