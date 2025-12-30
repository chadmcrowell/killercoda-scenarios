## Step 7: Test quorum-based application

```bash
cat <<'EOF' | kubectl apply -f -
apiVersion: v1
kind: Service
metadata:
  name: etcd-cluster
spec:
  clusterIP: None
  selector:
    app: etcd
  ports:
  - port: 2379
    name: client
  - port: 2380
    name: peer
---
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: etcd
spec:
  serviceName: etcd-cluster
  replicas: 3
  selector:
    matchLabels:
      app: etcd
  template:
    metadata:
      labels:
        app: etcd
    spec:
      containers:
      - name: etcd
        image: quay.io/coreos/etcd:v3.5.9
        ports:
        - containerPort: 2379
          name: client
        - containerPort: 2380
          name: peer
        env:
        - name: ETCD_NAME
          valueFrom:
            fieldRef:
              fieldPath: metadata.name
        - name: ETCD_INITIAL_CLUSTER
          value: "etcd-0=http://etcd-0.etcd-cluster:2380,etcd-1=http://etcd-1.etcd-cluster:2380,etcd-2=http://etcd-2.etcd-cluster:2380"
        - name: ETCD_INITIAL_CLUSTER_STATE
          value: "new"
        - name: ETCD_INITIAL_ADVERTISE_PEER_URLS
          value: "http://$(ETCD_NAME).etcd-cluster:2380"
        - name: ETCD_ADVERTISE_CLIENT_URLS
          value: "http://$(ETCD_NAME).etcd-cluster:2379"
        - name: ETCD_LISTEN_CLIENT_URLS
          value: "http://0.0.0.0:2379"
        - name: ETCD_LISTEN_PEER_URLS
          value: "http://0.0.0.0:2380"
EOF

kubectl wait --for=condition=Ready pods -l app=etcd --timeout=120s
kubectl exec etcd-0 -- etcdctl --endpoints=http://localhost:2379 endpoint health
```{{exec}}

Deploy a 3-node etcd to demonstrate quorum behavior.
