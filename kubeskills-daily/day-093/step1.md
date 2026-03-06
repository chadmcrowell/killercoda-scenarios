# Step 1 — Investigate the Problem

Set up the namespace exactly as the team-alpha environment looks today, then reproduce the failure.

## Create the Namespace, Quota, and LimitRange

```bash
kubectl create namespace team-alpha
```{{exec}}

Apply the ResourceQuota that the platform team provisioned for this namespace:

```bash
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: ResourceQuota
metadata:
  name: team-alpha-quota
  namespace: team-alpha
spec:
  hard:
    pods: "6"
    requests.cpu: "1000m"
    requests.memory: "512Mi"
    limits.cpu: "2000m"
    limits.memory: "1Gi"
EOF
```{{exec}}

Apply the LimitRange that enforces default resource values when pods don't specify any:

```bash
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: LimitRange
metadata:
  name: team-alpha-limits
  namespace: team-alpha
spec:
  limits:
  - type: Container
    default:
      cpu: "200m"
      memory: "128Mi"
    defaultRequest:
      cpu: "100m"
      memory: "64Mi"
    max:
      cpu: "500m"
      memory: "256Mi"
EOF
```{{exec}}

Confirm both are in place:

```bash
kubectl get resourcequota,limitrange -n team-alpha
```{{exec}}

## Deploy the Pre-Existing Workloads

The `frontend` team deployed their service with explicit resource requests:

```bash
cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: frontend
  namespace: team-alpha
spec:
  replicas: 2
  selector:
    matchLabels:
      app: frontend
  template:
    metadata:
      labels:
        app: frontend
    spec:
      containers:
      - name: frontend
        image: nginx:1.25
        resources:
          requests:
            cpu: "200m"
            memory: "128Mi"
          limits:
            cpu: "400m"
            memory: "256Mi"
EOF
```{{exec}}

The `cache` team deployed their service **without** specifying any resource requests — they said it "uses almost nothing":

```bash
cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: cache
  namespace: team-alpha
spec:
  replicas: 2
  selector:
    matchLabels:
      app: cache
  template:
    metadata:
      labels:
        app: cache
    spec:
      containers:
      - name: cache
        image: busybox:1.35
        command: ["sh", "-c", "sleep 3600"]
EOF
```{{exec}}

Wait for both Deployments to reach ready state:

```bash
kubectl get deployments -n team-alpha
```{{exec}}

Both show `2/2 READY`. The namespace has 4 running pods consuming some portion of the quota.

## Deploy the Failing Workload

Now deploy the `api-server` that is supposed to scale to 4 replicas:

```bash
cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: api-server
  namespace: team-alpha
spec:
  replicas: 4
  selector:
    matchLabels:
      app: api-server
  template:
    metadata:
      labels:
        app: api-server
    spec:
      containers:
      - name: api
        image: nginx:1.25
        resources:
          requests:
            cpu: "150m"
            memory: "64Mi"
          limits:
            cpu: "300m"
            memory: "128Mi"
EOF
```{{exec}}

Wait 10 seconds and check Deployment status:

```bash
kubectl get deployments -n team-alpha
```{{exec}}

```text
NAME         READY   UP-TO-DATE   AVAILABLE
api-server   2/4     4            2
cache        2/2     2            2
frontend     2/2     2            2
```

`api-server` is stuck at 2/4. The cluster has capacity. The pods are not in an error state. From the outside, something invisible is blocking two more pods from being created.

Check pod status to confirm no errors at the pod level:

```bash
kubectl get pods -n team-alpha
```{{exec}}

All running pods are `Running`. There are simply no pods being created for the missing 2 replicas — not even Pending pods.
