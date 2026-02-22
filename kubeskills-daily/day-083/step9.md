## Step 9: Test split-brain scenario

```bash
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Service
metadata:
  name: etcd
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
  serviceName: etcd
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
        image: quay.io/coreos/etcd:v3.5.0
        env:
        - name: ETCD_NAME
          valueFrom:
            fieldRef:
              fieldPath: metadata.name
        - name: ETCD_INITIAL_CLUSTER
          value: "etcd-0=http://etcd-0.etcd:2380,etcd-1=http://etcd-1.etcd:2380,etcd-2=http://etcd-2.etcd:2380"
        - name: ETCD_INITIAL_CLUSTER_STATE
          value: "new"
        - name: ETCD_LISTEN_PEER_URLS
          value: "http://0.0.0.0:2380"
        - name: ETCD_LISTEN_CLIENT_URLS
          value: "http://0.0.0.0:2379"
        - name: ETCD_ADVERTISE_CLIENT_URLS
          value: "http://\$(ETCD_NAME).etcd:2379"
        - name: ETCD_INITIAL_ADVERTISE_PEER_URLS
          value: "http://\$(ETCD_NAME).etcd:2380"
        ports:
        - containerPort: 2379
          name: client
        - containerPort: 2380
          name: peer
  volumeClaimTemplates:
  - metadata:
      name: data
    spec:
      accessModes: ["ReadWriteOnce"]
      resources:
        requests:
          storage: 1Gi
EOF

kubectl wait --for=condition=Ready pod -l app=etcd --timeout=120s

echo "etcd cluster deployed"
echo ""
echo "Split-brain risk:"
echo "- If network partitions cluster"
echo "- Each partition might elect leader"
echo "- Data divergence"
echo "- Quorum loss"
```{{exec}}

A 3-node etcd cluster requires quorum (2 of 3) to elect a leader. Network partitions can cause split-brain where each partition believes it is the primary, leading to data divergence.
