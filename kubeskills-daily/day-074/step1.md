## Step 1: Create test data to backup

```bash
# Create namespace with resources
kubectl create namespace backup-test

# Deploy StatefulSet with PVC
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Service
metadata:
  name: database
  namespace: backup-test
spec:
  clusterIP: None
  selector:
    app: db
  ports:
  - port: 5432
---
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: postgres
  namespace: backup-test
spec:
  serviceName: database
  replicas: 1
  selector:
    matchLabels:
      app: db
  template:
    metadata:
      labels:
        app: db
    spec:
      containers:
      - name: postgres
        image: postgres:15-alpine
        env:
        - name: POSTGRES_PASSWORD
          value: testpass
        - name: PGDATA
          value: /var/lib/postgresql/data/pgdata
        volumeMounts:
        - name: data
          mountPath: /var/lib/postgresql/data
        ports:
        - containerPort: 5432
  volumeClaimTemplates:
  - metadata:
      name: data
    spec:
      accessModes: ["ReadWriteOnce"]
      resources:
        requests:
          storage: 1Gi
EOF

kubectl wait --for=condition=Ready pod -n backup-test postgres-0 --timeout=120s

# Insert test data
kubectl exec -n backup-test postgres-0 -- psql -U postgres -c "
  CREATE TABLE users (id SERIAL PRIMARY KEY, name VARCHAR(50));
  INSERT INTO users (name) VALUES ('Alice'), ('Bob'), ('Charlie');
"

# Verify data
kubectl exec -n backup-test postgres-0 -- psql -U postgres -c "SELECT * FROM users;"
```{{exec}}

Test database with sample data created.
