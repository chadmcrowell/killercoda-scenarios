Now that we've seen version 1 of the app, let's do the same for version 2. The web page will view differently.

Again click on the menu in the upper right, and selecting "Traffic / Ports". This time, in the "Custom Ports" field, enter `30000` and click the "Access" button

The web page will appear and say "Hello Green"
![hello green web app](./assets/hello-green-app-in-browser.png)

Now, let's perform a blue/green deployment by changing the service named `svc-java-blue`. 

Instead of the service `svc-java-blue` selecting the pods in the `hello-java-blue` deployment, let's have it select the pods within the `hello-java-green` deployment.

You should see a file in your current directory named `svc-spring-boot-blue.yaml`. You can view the file with the command `ls | grep blue`{{exec}}

Open the file with the command `vim svc-spring-boot-blue.yaml`{{exec}}

With the file open, change the selector to `app: hello-java-green` and `version: v2`. The file should look like this:

<br>
<details><summary>Click here to see the final result of the YAML file</summary>
<br>

```yaml
apiVersion: v1
kind: Service
metadata:
  labels:
    app: hello-java-blue
    version: v1
  name: svc-java-blue
spec:
  ports:
  - port: 8080
    protocol: TCP
    targetPort: 8080
    nodePort: 30001
  selector:
    app: hello-java-green
    version: v2
  type: NodePort
```

</details>

Save the file and exit out of vim. (`wq!`)

Apply the YAML file and change the existing service with the command `k apply -f svc-spring-boot-blue.yaml`{{exec}}

Now, when you visit port `30001`, the web page should display "Hello, Green"

___
## CHALLENGE

Perform a blue/green deployment for the green app. Instead of switching from version 1 to version 2 of the app, switch from version 2 to version 1. Now, when you visit the web page on port `30000`, you will see "Hello, Blue"

<br>
<details><summary>Solution</summary>
<br>

```plain
# open the file named svc-spring-boot-green.yaml
vim svc-spring-boot-green.yaml
```{{exec}}

The final result of the YAML file should look like this:
```yaml
apiVersion: v1
kind: Service
metadata:
  labels:
    app: hello-java-green
    version: v2
  name: svc-java-green
spec:
  ports:
  - port: 8080
    protocol: TCP
    targetPort: 8080
    nodePort: 30000
  selector:
    app: hello-java-blue
    version: v1
  type: NodePort
```{{exec}}

```plain
# modify the existing service by applying the YAML file
k apply -f svc-spring-boot-green.yaml 
```

Now, when you visit port `30001`, the web page should display "Hello, Green" 

</details>