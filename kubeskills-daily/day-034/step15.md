## Step 15: Test hierarchical namespaces (conceptual)

```bash
cat <<'NS' | kubectl apply -f -
apiVersion: v1
kind: Namespace
metadata:
  name: team-a-dev
  labels:
    team: a
    environment: dev
NS

kubectl apply -n team-a-dev -f - <<'RQ'
apiVersion: v1
kind: ResourceQuota
metadata:
  name: team-quota
spec:
  hard:
    requests.cpu: "500m"
    requests.memory: "1Gi"
RQ
```{{exec}}

Shows a child namespace pattern similar to HNC inheritance.
