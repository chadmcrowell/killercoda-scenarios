## Step 9: Count-based quotas

```bash
cat <<EOF | kubectl apply -n quota-test -f -
apiVersion: v1
kind: ResourceQuota
metadata:
  name: count-quota
spec:
  hard:
    count/deployments.apps: "3"
    count/services: "5"
    count/secrets: "10"
    count/configmaps: "10"
EOF
```{{exec}}

```bash
for i in {1..5}; do kubectl create deployment test-$i --image=nginx -n quota-test; done
```{{exec}}

The fourth deployment should fail due to the count quota limit.
