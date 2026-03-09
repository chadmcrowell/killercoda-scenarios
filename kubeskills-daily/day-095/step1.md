# Step 1 — Investigate the Problem

Set up the broken environment that the dev tools team left behind, then trace the failure from the pod down to the storage layer.

## Create the Namespace and Deploy the Application

The dev tools team deployed a Gitea self-hosted Git server in the `dev-tools` namespace. They copied a Helm-generated manifest from a cloud environment and applied it without modification. Reproduce their setup:

```bash
kubectl create namespace dev-tools
```{{exec}}

Create the PersistentVolumeClaim the Gitea pod will mount for repository data. The cloud template hardcoded `ssd-retain` as the StorageClass:

```bash
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: gitea-repos
  namespace: dev-tools
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 5Gi
  storageClassName: ssd-retain
EOF
```{{exec}}

Deploy the Gitea pod that mounts this claim:

```bash
cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: gitea
  namespace: dev-tools
spec:
  replicas: 1
  selector:
    matchLabels:
      app: gitea
  template:
    metadata:
      labels:
        app: gitea
    spec:
      containers:
      - name: gitea
        image: gitea/gitea:1.21
        ports:
        - containerPort: 3000
        - containerPort: 22
        volumeMounts:
        - name: repo-data
          mountPath: /data
      volumes:
      - name: repo-data
        persistentVolumeClaim:
          claimName: gitea-repos
EOF
```{{exec}}

## Observe the Failure

Check the pod status:

```bash
kubectl get pods -n dev-tools
```{{exec}}

```text
NAME                     READY   STATUS    RESTARTS   AGE
gitea-7d9f8c6b5-mnpq2    0/1     Pending   0          12s
```

The pod is stuck in `Pending`. This is different from `CrashLoopBackOff` or `ImagePullBackOff` — there is no container running yet at all. The scheduler has not placed the pod on any node. Check why:

```bash
kubectl describe pod -n dev-tools -l app=gitea
```{{exec}}

Scroll to the `Events` section at the bottom of the output:

```text
Events:
  Type     Reason            Age   From               Message
  ----     ------            ----  ----               -------
  Warning  FailedScheduling  8s    default-scheduler  0/2 nodes are available:
           2 pod has unbound immediate PersistentVolumeClaims.
```

The scheduler is refusing to place the pod because the PVC it needs has not been bound to a PersistentVolume. Kubernetes requires the storage claim to be satisfied before committing a pod to a node — otherwise the container would start and immediately fail trying to mount a volume that does not exist.

## Inspect the PVC

The problem is in the PVC, not the pod. Check it directly:

```bash
kubectl get pvc -n dev-tools
```{{exec}}

```text
NAME           STATUS    VOLUME   CAPACITY   ACCESS MODES   STORAGECLASS   AGE
gitea-repos    Pending                                      ssd-retain     40s
```

`STATUS` is `Pending` and `VOLUME` is empty — no PersistentVolume was created or claimed. Describe the PVC to read the events from the storage controller:

```bash
kubectl describe pvc gitea-repos -n dev-tools
```{{exec}}

```text
Name:          gitea-repos
Namespace:     dev-tools
StorageClass:  ssd-retain
Status:        Pending
Volume:
...
Events:
  Type     Reason                Age   From                         Message
  ----     ------                ----  ----                         -------
  Warning  ProvisioningFailed    12s   persistentvolume-controller  storageclass.storage.k8s.io "ssd-retain" not found
```

The storage controller is reporting exactly what is wrong: `storageclass.storage.k8s.io "ssd-retain" not found`. There is no StorageClass with that name registered in this cluster, so no provisioner received the request, no PersistentVolume was created, and the pod has no storage to mount.
