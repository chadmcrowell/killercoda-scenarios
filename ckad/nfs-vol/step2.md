> NOTE: You're prompt should look like this `controlplane $ `

look at the pod yaml for the pod that will mount the nfs volume from the nfs server we just setup on node01 with the command `cat pod-nfs-vol.yaml`{{exec}}

The contents should look like the following:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: test
spec:
  containers:
    - name: alpine
      image: alpine:latest
      command: [ 'sh', '-c', 'while true; do echo "some text" >> /data/test; sleep 3600; done' ]
      volumeMounts:
        - name: nfs-volume
          mountPath: /data
  volumes:
    - name: nfs-volume
      nfs:
        server: 172.30.2.2
        path: /data
        readOnly: no
```

Now create the pod with the command `k create -f pod-nfs-vol.yaml`{{exec}}

List the pods in the default namespace with the command `k get po`{{exec}}

The output should look like similar to the following:
```bash
NAME   READY   STATUS    RESTARTS   AGE
test   1/1     Running   0          118s
```