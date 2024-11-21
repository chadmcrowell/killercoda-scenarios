Let's create a simple Postgres cluster. You can do this by executing the following command.
```bash
k apply -k kustomize/postgres
```{{exec}}

This will create a Postgres cluster named `hippo` in the `postgres-operator` namespace.

You can track the progress of your cluster using the following commands.
```bash
k -n postgres-operator get postgresclusters

k -n postgres-operator describe postgresclusters hippo
```{{copy}}

As part of creating a Postgres cluster, the Postgres Operator creates a PostgreSQL user account. The credentials for this account are stored in a Secret that has the name `hippo-pguser-rhino`.

List the secres in the `postgres-operator` namespace with the following command.
```bash
k -n postgres-operator get secrets
```

Open a new tab by clicking the plus sign at the top of the window, and create a port forward. You can run the following commands to create a port forward.
```bash
export PG_CLUSTER_PRIMARY_POD=$(kubectl get pod -n postgres-operator -o name -l postgres-operator.crunchydata.com/cluster=hippo,postgres-operator.crunchydata.com/role=master)

kubectl -n postgres-operator port-forward "${PG_CLUSTER_PRIMARY_POD}" 5432:5432
```

Establish a connection to the PostgreSQL cluster.  You can run the following commands to store the username, password, and database in an environment variable and connect.
```bash
export PG_CLUSTER_USER_SECRET_NAME=hippo-pguser-rhino

export PGPASSWORD=$(kubectl get secrets -n postgres-operator "${PG_CLUSTER_USER_SECRET_NAME}" -o go-template='{{.data.password | base64decode}}')

export PGUSER=$(kubectl get secrets -n postgres-operator "${PG_CLUSTER_USER_SECRET_NAME}" -o go-template='{{.data.user | base64decode}}')

export PGDATABASE=$(kubectl get secrets -n postgres-operator "${PG_CLUSTER_USER_SECRET_NAME}" -o go-template='{{.data.dbname | base64decode}}')

psql -h localhost
```

Create a Schema with the following command.
```bash
CREATE SCHEMA rhino AUTHORIZATION rhino;

```

In PostgreSQL, creating a schema establishes a namespace within a database that can organize and isolate database objects such as tables, views, indexes, functions, and other entities. It allows for better management of database objects, particularly in environments where multiple users or applications interact with the same database.

Exit out of the postgres cli.