
To interact with the etcd datastore in Kubernetes, we use a command-line tool called **etcdctl**

> 🔥TIP: etcd has its own server certificate which requires a valid client certificate and key located in `/etc/kubernetes/pki/etcd`

Just like the Kubernetes API, the etcd datastore requires authenticaiton which can be passed as a parameter with the **etcdctl** tool. **etcdctl** also requires environment variable `ETCDCTL_API` which is set to the version of **etcdctl**

Set this environment variable before you backup the etcd datastore with the command

`export ETCDCTL_API=3`

Backup the etcd datastore with the `etcdctl snapshot save` command and pass in the certificate authority, the client or server certificate, and the private key in order to authenticate with etcd. We'll name the snapshot file "snapshot".

`etcdctl snapshot save snapshot --cacert /etc/kubernetes/pki/etcd/ca.crt --cert /etc/kubernetes/pki/etcd/server.crt --key /etc/kubernetes/pki/etcd/server.key`

Listing the contents of your current directory will now look like this:
```bash
$ ls
snap snapshot
```

Check the status of your snapshot and write the output to a table using this command

`etcdctl snapshot status snapshot --write-out=table`