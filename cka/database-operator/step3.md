Scaling a PostgreSQL cluster managed by the Crunchy Data Postgres Operator involves modifying the `PostgresCluster` Custom Resource Definition (CRD) to adjust the number of PostgreSQL instances (pods). The operator will handle the scaling process automatically once the changes are applied.

Fetch the current `PostgresCluster` YAML configuration to understand its structure. Look for the `instances` section under the `spec` field.
```bash
k -n postgres-operator get postgresclusters hippo -o yaml
```{{copy}}

Edit the `hippo` postgres cluster in order to change the replica count.
```bash
kubectl edit postgresclusters hippo -n postgres-operator
```{{copy}}

To scale the cluster, increase the number of replicas in the `PostgresCluster` to 3. 
```yaml
spec:
  instances:
  - name: instance1
    replicas: 3
```

Once the `PostgresCluster` resource is updated, the operator will detect the change and manage the scaling process. The operator will create 2 new pods.
```bash
kubectl -n postgres-operator get pods
```{{copy}}

You can connect to the PostgreSQL service to verify it is handling requests correctly. The operator manages replicas and ensures the primary and replicas are in sync.

If necessary, check the logs of the operator for scaling-related messages.
```bash
kubectl logs -n postgres-operator -l postgres-operator.crunchydata.com/control-plane=postgres-operator
```{{copy}}