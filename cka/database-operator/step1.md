Create an Ingress resource that will allow you to resolve the domain name hello.com to the service named `apache-svc` over port `80`.

> HINT: During the exam, you will be able to access kubernetes.io/docs. Search for the word "ingress" within the docs for YAML that you can copy and paste into your terminal!

<br>
<details><summary>Solution</summary>
<br>

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: minimal-ingress
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
spec:
  ingressClassName: nginx
  rules:
  - host: "hello.com"
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: apache-svc
            port:
              number: 80
```{{copy}}


</details>