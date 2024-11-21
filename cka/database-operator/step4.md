Simulating a pod failure in a Crunchy Data Postgres Operator-managed PostgreSQL cluster is a straightforward way to test the operator’s recovery mechanisms. 

List the pods in your PostgreSQL cluster namespace.
```bash
k -n postgres-operator get pods
```{{copy}}

You can tell which pod is the leader with the following command.
```bash
k -n postgres-operator get pods --show-labels | grep role
```{{exec}}

Choose a pod to delete (e.g., `hippo-instance1-0` for the primary or a replica)
```bash
k -n postgres-operator delete po hippo-instance1-0 
```{{copy}}

This will simulate a failure by removing the pod.

The Crunchy Postgres Operator will automatically detect the failure and attempt to recover the pod.
```bash
k -n postgres-operator get pods  -w
```{{copy}}

Check the `PostgresCluster` resource for events related to the recovery.
```bash
k -n postgres-operator describe postgresclusters hippo
```{{copy}}

Look for events such as:
- The operator creating a new pod.
- Replica promotion (if the primary is deleted).
- Synchronization completion.

Check the operator logs for detailed information about how it handles the failure.
```bash
k -n postgres-operator logs -l postgres-operator.crunchydata.com/control-plane=postgres-operator
```{{copy}}

Look for messages about:
- Pod recreation
- Replica promotion (if necessary)
- Readiness checks

Connect to the PostgreSQL database and run some basic queries to ensure it is functioning properly.
```bash
psql -h localhost

SELECT pg_is_in_recovery();
```{{copy}}

- `t`: Indicates the node is a replica.
- `f`: Indicates the node is the primary.

Since we deleted a replica, confirm replication is still functioning.
```bash
kubectl exec -it -n postgres-operator <replica-pod-name> -- psql -U postgres -d postgres
```{{copy}}

```bash
SELECT pg_last_wal_replay_lsn();
```{{copy}}

This shows the replication status from the primary’s perspective.