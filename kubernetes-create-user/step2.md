
Let's create a pod in the web namespace, so our new user has something to look at!

`k -n web run pod1 --image=nginx`

The output 'get pods' in the web namespace will look like this
```bash
$ k -n web get po
NAME   READY   STATUS    RESTARTS   AGE
pod1   1/1     Running   0          2m33s
```