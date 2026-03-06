# Step 1 — Investigate the Problem

Set up the broken environment exactly as the data platform team left it, then trace the failure from the pod down to the storage layer.

## Create the Namespace and Deploy the Database

The data platform team deployed a PostgreSQL database in the `data-tier` namespace. Reproduce their setup:

```bash
kubectl create namespace data-tier
```{{exec}}

Create the PersistentVolumeClaim that the database pod will mount. The team migrated from a cloud environment and specified `fast-ssd` as the StorageClass:

```bash
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: postgres-data
  namespace: data-tier
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 1Gi
  storageClassName: fast-ssd
EOF
```{{exec}}

Deploy the PostgreSQL pod that mounts this claim:

```bash
cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: postgres
  namespace: data-tier
spec:
  replicas: 1
  selector:
    matchLabels:
      app: postgres
  template:
    metadata:
      labels:
        app: postgres
    spec:
      containers:
      - name: postgres
        image: postgres:15
        env:
        - name: POSTGRES_PASSWORD
          value: "secretpassword"
        - name: PGDATA
          value: /var/lib/postgresql/data/pgdata
        volumeMounts:
        - name: data
          mountPath: /var/lib/postgresql/data
      volumes:
      - name: data
        persistentVolumeClaim:
          claimName: postgres-data
EOF
```{{exec}}

## Observe the Failure

Check the pod status:

```bash
kubectl get pods -n data-tier
```{{exec}}

```text
NAME                        READY   STATUS    RESTARTS   AGE
postgres-6d8f7c9b4d-xk2p9   0/1     Pending   0          15s
```

The pod is stuck in `Pending`. Unlike a crash or an image pull failure, there is no container to inspect — the pod never started. Check why:

```bash
kubectl describe pod -n data-tier -l app=postgres
```{{exec}}

Scroll to the `Events` section at the bottom:

```text
Events:
  Type     Reason            Age   From               Message
  ----     ------            ----  ----               -------
  Warning  FailedScheduling  10s   default-scheduler  0/2 nodes are available:
           2 pod has unbound immediate PersistentVolumeClaims.
```

The scheduler cannot place the pod because its PVC has not been bound. The scheduler refuses to schedule a pod that is waiting for storage — it would just crash on startup if it did. The root cause is in the PVC, not the pod.

## Inspect the PVC

Check the PVC status directly:

```bash
kubectl get pvc -n data-tier
```{{exec}}

```text
NAME            STATUS    VOLUME   CAPACITY   ACCESS MODES   STORAGECLASS   AGE
postgres-data   Pending                                      fast-ssd       45s
```

`STATUS` is `Pending` and `VOLUME` is empty — no PersistentVolume has been created or bound. Describe the PVC to read the events from the storage layer:

```bash
kubectl describe pvc postgres-data -n data-tier
```{{exec}}

```text
Name:          postgres-data
Namespace:     data-tier
StorageClass:  fast-ssd
Status:        Pending
Volume:
...
Events:
  Type     Reason                Age   From                         Message
  ----     ------                ----  ----                         -------
  Warning  ProvisioningFailed    10s   persistentvolume-controller  storageclass.storage.k8s.io "fast-ssd" not found
```

The control plane is reporting: `storageclass.storage.k8s.io "fast-ssd" not found`. The PVC is referencing a StorageClass that does not exist in this cluster. No provisioner received the request, no PersistentVolume was created, and the pod has nowhere to mount.
