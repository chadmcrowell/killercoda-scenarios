Use the CLI tool that will allow you to view the client certificate that the kubelet uses to authenticate to the Kubernetes API. Output the results to a file named “kubelet-config.txt”.

<br>
<details><summary>Solution</summary>
<br>

```bash
# view the config that kubelet uses to authenticate to the Kubernetes API
cat /etc/kubernetes/kubelet.conf > kubelet-config.txt

# view the certificate using openssl. Get the certificate file location from the 'kubelet.conf' file above. 
openssl x509 -in /var/lib/kubelet/pki/kubelet-client-current.pem -text -noout

```{{exec}}


</details>