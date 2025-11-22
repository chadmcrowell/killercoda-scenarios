## Step 5: Test DNS resolution timing

```bash
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: dns-timing-test
spec:
  containers:
  - name: test
    image: busybox
    command: ['sh', '-c', '
      echo "Starting DNS resolution test...";
      for i in $(seq 1 20); do
        START=$(date +%s%N);
        nslookup backend-svc > /dev/null 2>&1;
        END=$(date +%s%N);
        DURATION=$(( ($END - $START) / 1000000 ));
        echo "Query $i: ${DURATION}ms";
        sleep 1;
      done
    ']
EOF
```{{exec}}

```bash
kubectl logs dns-timing-test -f
```{{exec}}

Expect the first query to be slower (cache miss) and later ones faster due to caching.
