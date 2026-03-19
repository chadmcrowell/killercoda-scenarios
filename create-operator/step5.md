# Step 5: Run the Operator

With the controller code and RBAC annotations in place, regenerate the manifests and run the operator.

First, regenerate the RBAC manifests from the new annotations:

```bash
cd ~/src && make manifests && make install
```{{exec}}

Open a new terminal tab by clicking the `+` sign next to `Tab 1`. In **Tab 2**, run the operator:

```bash
cd ~/src && make run
```{{exec}}

Wait until you see output like:

```
INFO    Starting workers    {"controller": "website", "worker count": 1}
```

Then return to **Tab 1** and apply the sample Website custom resource:

```bash
kubectl apply -f ~/src/config/samples/killercoda_v1beta1_website.yaml
```{{exec}}

Verify the Website resource was created:

```bash
kubectl get websites
```{{exec}}

Verify the operator responded by creating a Deployment:

```bash
kubectl get deployments
```{{exec}}

You should see a deployment created by the operator for your Website resource. Press `ctrl + c` in Tab 2 to stop the operator.
