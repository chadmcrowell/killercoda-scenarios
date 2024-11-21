First, go to GitHub and [fork the Postgres Operator examples](https://github.com/CrunchyData/postgres-operator-examples/fork) repository.

Once you have forked this repo, you can clone your forked repo with the following commands:L
```bash
# set your username
export GITHUB_USERNAME="<your-github-username>"
```

```bash
# clone the repo
git clone --depth 1 "https://github.com/${GITHUB_USERNAME}/postgres-operator-examples.git"

# change directory 
cd postgres-operator-examples
```{{copy}}

You can install PGO, the Postgres Operator from Crunchy Data, using the following command.
```bash
kubectl apply -k kustomize/install/namespace
kubectl apply --server-side -k kustomize/install/default
```{{copy}}

This will create a namespace called `postgres-operator` and create all of the objects required to deploy PGO.

To check on the status of your installation, you can run the following command.
```bash
k -n postgres-operator get po -w

k get crds | grep postgres
```

If the PGO Pod is healthy, you should see output similar to this.
```bash
NAME                                READY   STATUS    RESTARTS   AGE
postgres-operator-9dd545d64-t4h8d   1/1     Running   0          3s
```
