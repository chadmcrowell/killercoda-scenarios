# Step 1 — Investigate the Problem

Two services have HPAs configured but both are stuck at `<unknown>` for their metrics target. Deploy the resources and reproduce the issue.

## Deploy the Two Services

Deploy the `api-server` Deployment. This one has CPU resource requests correctly defined:

```bash
cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: api-server
  namespace: default
spec:
  replicas: 1
  selector:
    matchLabels:
      app: api-server
  template:
    metadata:
      labels:
        app: api-server
    spec:
      containers:
      - name: api-server
        image: nginx:1.25
        resources:
          requests:
            cpu: "100m"
            memory: "64Mi"
          limits:
            cpu: "200m"
            memory: "128Mi"
EOF
```{{exec}}

Deploy the `worker` Deployment. This one was deployed without any resource requests:

```bash
cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: worker
  namespace: default
spec:
  replicas: 1
  selector:
    matchLabels:
      app: worker
  template:
    metadata:
      labels:
        app: worker
    spec:
      containers:
      - name: worker
        image: nginx:1.25
EOF
```{{exec}}

Confirm both pods are running:

```bash
kubectl get pods
```{{exec}}

## Create the HPAs

Create an HPA for each Deployment targeting 50% average CPU utilization:

```bash
cat <<EOF | kubectl apply -f -
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: api-server-hpa
  namespace: default
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: api-server
  minReplicas: 1
  maxReplicas: 5
  metrics:
  - type: Resource
    resource:
      name: cpu
      target:
        type: Utilization
        averageUtilization: 50
---
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: worker-hpa
  namespace: default
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: worker
  minReplicas: 1
  maxReplicas: 5
  metrics:
  - type: Resource
    resource:
      name: cpu
      target:
        type: Utilization
        averageUtilization: 50
EOF
```{{exec}}

## Observe the Failure

Check the HPA status:

```bash
kubectl get hpa
```{{exec}}

Both HPAs report `<unknown>/50%` in the TARGETS column:

```text
NAME             REFERENCE               TARGETS         MINPODS   MAXPODS   REPLICAS
api-server-hpa   Deployment/api-server   <unknown>/50%   1         5         1
worker-hpa       Deployment/worker       <unknown>/50%   1         5         1
```

`<unknown>` means the HPA controller cannot read the current metric value. Without a current reading it cannot decide whether to scale up or down — autoscaling is completely inactive for both services.

Look for warning events on both HPAs:

```bash
kubectl describe hpa api-server-hpa | tail -15
```{{exec}}

```bash
kubectl describe hpa worker-hpa | tail -15
```{{exec}}

Note the warning messages in the Events section — they point directly at the root cause for each HPA.
