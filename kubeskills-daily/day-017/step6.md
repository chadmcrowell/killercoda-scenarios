## Step 6: Deploy a working webhook (simple example)

```bash
cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: simple-webhook
spec:
  replicas: 1
  selector:
    matchLabels:
      app: webhook
  template:
    metadata:
      labels:
        app: webhook
    spec:
      containers:
      - name: webhook
        image: hashicorp/http-echo
        args:
        - "-text={\"apiVersion\":\"admission.k8s.io/v1\",\"kind\":\"AdmissionReview\",\"response\":{\"uid\":\"REQUEST_UID\",\"allowed\":true}}"
        - "-listen=:8443"
        ports:
        - containerPort: 8443
---
apiVersion: v1
kind: Service
metadata:
  name: webhook-svc
spec:
  selector:
    app: webhook
  ports:
  - port: 443
    targetPort: 8443
EOF
```{{exec}}

```bash
kubectl get pods -l app=webhook
```{{exec}}

Wait for the webhook pod to be Running.
