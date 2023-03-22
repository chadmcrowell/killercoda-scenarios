Check if the service is defined correctly, including it's ports and type

Run the command to output the service YAML

Verify the service is correctly defined by asking the following:
- Is the Service port you are trying to access listed in spec.ports[]?
- Is the targetPort correct for your Pods (some Pods use a different port than the Service)?
- If you meant to use a numeric port, is it a number (9376) or a string "9376"?
- If you meant to use a named port, do your Pods expose a port with the same name?
- Is the port's protocol correct for your Pods?

Let's check that the Pods you ran are actually being selected by the Service

Run the command to view the service endpoints.

If the ENDPOINTS column is `<none>`, you should check that the `spec.selector` field of your Service actually selects for `metadata.labels` values on your Pods. A common mistake is to have a typo or other error, such as the Service selecting for `app=hostnames`, but the Deployment specifying `run=hostnames`, as in versions previous to 1.18, where the `kubectl run` command could have been also used to create a Deployment

<br>
<details><summary>Solution</summary>
<br>

```plain
kubectl get service hostnames -o yaml

kubectl get endpoints hostnames
```{{exec}}

</details>