
Role-based access in Kubernetes is used to permit actions being performed by users or service accounts on Kubernetes API resources. There are no "deny" rules in RBAC, so you must be careful to set actions that are absolutely necessary for that user or service account.

**Roles** are created in Kubernetes to assign the access (e.g. get, list, delete, etc.) to a Kubernetes resource in a given namespace

**RoleBindings** are created within a namespace and attached to **Roles** in order to assign that resource's permission to the service account or user

> 🔥TIP🔥: ClusterRoles and ClusterRoleBindings work in the same way, but apply across ALL namespaces (cluster-wide)

In order to create a **Role** and **RoleBinding** in a namespace, we have to create the namespace "web" using the command

`k create ns web`{{exec}}

Now, let's creat the role that will allow our new user to "get" and "list" pods in the web namespace

`k -n web create role pod-reader --verb=get,list --resource=pods`{{exec}}

Now that we've created a role, let's assign this role to our new user named 'carlton'

`k -n web create rolebinding pod-reader-binding --role=pod-reader --user=carlton`{{exec}}

`k -n web get role,rolebinding`{{exec}}

The output of role and rolebinding in your terminal should look like this
```bash
$ k -n web get role,rolebinding
NAME                                        CREATED AT
role.rbac.authorization.k8s.io/pod-reader   2022-03-23T21:45:51Z

NAME                                                       ROLE              AGE
rolebinding.rbac.authorization.k8s.io/pod-reader-binding   Role/pod-reader   8s
```