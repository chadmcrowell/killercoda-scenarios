Now that our pod is created, and it's using the volume that we provisioned, let's write some data to the volume and see if the data persists beyond the life of the pod.

We'll start by getting a shell to the container in the pod `pv-pod` and performing the command:
```bash
echo "<h1>This is my website!</h1>" > /usr/share/nginx/html/index.html
```{{copy}}

Once you've written that index.html file to the volume, go ahead and delete the pod.

Start a new pod with the same specifications, but name it `pv-pod2` instead of `pv-pod`. Get a shell to the nginx container running inside of `pv-pod2` and see if the `index.html` file is still there. If it is, that means that our data persisted beyond the life of a pod.

<br>
<details><summary>Solution</summary>
<br>

Get a shell to the container inside of `pv-pod`
```bash
k exec -it pv-pod -- sh
```{{exec}}

After you've executed the command at the top of this page (to write the file index.html), delete the pod named `pv-pod`
```bash
k delete po pv-pod
```

Create a new pod named `pv-pod2` with the same specs (the mount path and pvc name must be the same)
```bash
cat <<EOF | k apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: pv-pod2
spec:
  containers:
    - name: pv-container
      image: nginx
      volumeMounts:
        - mountPath: "/usr/share/nginx/html"
          name: pv-storage
  volumes:
    - name: pv-storage
      persistentVolumeClaim:
        claimName: pv-claim
EOF
```{{exec}}

Get a shell to the nginx container in pod `pv-pod2`
```bash
k exec -it pv-pod2 -- sh
```{{exec}}

From the shell to the container, see if the file `index.html` is still there
```bash
ls /usr/share/nginx/html/
```


</details>