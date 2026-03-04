# Step 3 — Apply the Fix

You know exactly what's wrong with each resource. Fix them one by one and confirm each applies cleanly.

## Fix 1 — Team Alpha: Add the Missing `port` Field

The original resource omitted the required `port` field. Add it:

```bash
cat <<EOF | kubectl apply -f -
apiVersion: kubeskills.io/v1alpha1
kind: WebApp
metadata:
  name: webapp-alpha
  namespace: default
spec:
  image: nginx:1.25
  tier: frontend
  port: 80
EOF
```{{exec}}

Expected output: `webapp.kubeskills.io/webapp-alpha created`

## Fix 2 — Team Beta: Use a Valid Enum Value

Change `tier: api` to a value the schema allows. This is a backend service, so use `backend`:

```bash
cat <<EOF | kubectl apply -f -
apiVersion: kubeskills.io/v1alpha1
kind: WebApp
metadata:
  name: webapp-beta
  namespace: default
spec:
  image: myapp:latest
  port: 8080
  tier: backend
EOF
```{{exec}}

Expected output: `webapp.kubeskills.io/webapp-beta created`

## Fix 3 — Team Gamma: Correct `replicas` and `healthPath`

Set `replicas` to at least `1` and add the leading `/` to `healthPath`:

```bash
cat <<EOF | kubectl apply -f -
apiVersion: kubeskills.io/v1alpha1
kind: WebApp
metadata:
  name: webapp-gamma
  namespace: default
spec:
  image: myapp:2.0
  port: 8080
  tier: backend
  replicas: 3
  healthPath: "/health"
EOF
```{{exec}}

Expected output: `webapp.kubeskills.io/webapp-gamma created`

## Verify All Three Resources Are in the Cluster

```bash
kubectl get webapps
```{{exec}}

All three should now appear:

```text
NAME           AGE
webapp-alpha   ...
webapp-beta    ...
webapp-gamma   ...
```

Inspect the stored specs to confirm the values were accepted correctly:

```bash
kubectl get webapp webapp-alpha -o jsonpath='{.spec}{"\n"}'
kubectl get webapp webapp-beta  -o jsonpath='{.spec}{"\n"}'
kubectl get webapp webapp-gamma -o jsonpath='{.spec}{"\n"}'
```{{exec}}

## Final Check: Confirm Validation Is Still Active

Try applying one more invalid resource to prove the schema is still enforcing rules:

```bash
cat <<EOF | kubectl apply -f -
apiVersion: kubeskills.io/v1alpha1
kind: WebApp
metadata:
  name: webapp-test
  namespace: default
spec:
  image: test:latest
  port: 99999
  tier: frontend
EOF
```{{exec}}

Expected rejection:

```text
The WebApp "webapp-test" is invalid:
  spec.port: Invalid value: 99999: spec.port in body should be less than or equal to 65535
```

The CRD validation is working correctly. All three teams are unblocked and their resources are live in the cluster.
