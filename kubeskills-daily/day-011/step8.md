## Step 8: Test init container DNS dependency

```bash
kubectl delete service backend-svc
```{{exec}}

```bash
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: init-dns-test
spec:
  initContainers:
  - name: wait-for-backend
    image: busybox
    command: ['sh', '-c', '
      echo "Waiting for backend-svc DNS...";
      for i in $(seq 1 30); do
        if nslookup backend-svc; then
          echo "Service found!";
          exit 0;
        fi;
        echo "Attempt $i failed, waiting...";
        sleep 2;
      done;
      echo "Timeout waiting for service";
      exit 1
    ']
  containers:
  - name: app
    image: nginx
EOF
```{{exec}}

```bash
kubectl get pod init-dns-test -w
kubectl logs init-dns-test -c wait-for-backend -f
```{{exec}}

Init container loops until DNS appears; main container waits.
