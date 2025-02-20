Fix the error by adding the PORT environment variable to the container. Start by looking at the Kubernetes documentation for help (as you are able to do on the CKA exam).

[Kubernetes Documentation](https://kubernetes.io/docs/tasks/inject-data-application/define-environment-variable-container/)

Test the app by accessing the service again using `curl http://<service-ip>:8080`{{copy}}

<br>
<details><summary>Solution</summary>
<br>

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: go-app
spec:
  replicas: 1
  selector:
    matchLabels:
      app: go-app
  template:
    metadata:
      labels:
        app: go-app
    spec:
      containers:
      - name: go-app
        image: your-dockerhub-username/go-app:latest
        ports:
        - containerPort: 8080
        env:
        - name: PORT
          value: "8080"


```

</details>