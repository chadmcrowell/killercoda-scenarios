You will see two different versions of our application, running as deployments in our Kubernetes cluster.

List the deployments with the command `k get deploy`{{exec}}

> ⚠️ The deployment may take up to 84 seconds for the deployment to startup and become ready. Keep trying the `k get deploy` command until you see 3/3 ready.

The output should look similar to the following:

```bash
NAME                  READY   UP-TO-DATE   AVAILABLE   AGE
hello-java-blue-v1    3/3     3            3           70s
hello-java-green-v2   3/3     3            3           70s
```

These two apps are exposed via two different services in Kubernetes.

List the services with the command `k get svc`{{exec}}

The output should look similar to the following:

```bash
NAME             TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)          AGE
kubernetes       ClusterIP   10.96.0.1      <none>        443/TCP          11d
svc-java-blue    NodePort    10.99.60.93    <none>        8080:30001/TCP   3m42s
svc-java-green   NodePort    10.97.210.25   <none>        8080:30000/TCP   3m41s
```

View the web page via the `nodePort` by clicking on the menu in the upper right, and selecting "Traffic / Ports" 
![Killercoda Traffic Ports Button](./assets/killercoda-traffic-ports.png)

In the "Custom Ports" field, enter `30000` and click the "Access" button

The web page will appear and say "Hello Blue"

___
## CHALLENGE

Create a deployment named `java-hello` that uses the image `chadmcrowell/hello-world-java` and apply the label `version=3` to the pods within that deployment. Create a `nodePort` service that will expose the deployment on port 8080 to the target pod on port 8080.

<br>
<details><summary>Solution</summary>
<br>

```plain
# create a YAML file "deploy.yaml" for a deployment using the image `chadmcrowell/hello-world-java`
k create deploy java-hello --image chadmcrowell/hello-world-java --dry-run=client -o yaml > deploy.yaml
```{{exec}}

The YAML file should look similar to the following:
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  creationTimestamp: null
  labels:
    app: java-hello
  name: java-hello
spec:
  replicas: 1
  selector:
    matchLabels:
      app: java-hello
  strategy: {}
  template:
    metadata:
      creationTimestamp: null
      labels:
        app: java-hello
        version: 3
    spec:
      containers:
      - image: chadmcrowell/hello-world-java
        name: hello-world-java
        resources: {}
status: {}
```

```plain
# create a service that exposes the deployment on port 8080
k expose deploy java-hello --port 8080 --target-port 8080 --type=nodePort
```{{exec}}

</details>