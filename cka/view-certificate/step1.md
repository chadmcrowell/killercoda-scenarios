Use the CLI tool that will allow you to view the client certificate that the kubelet uses to authenticate to the Kubernetes API. Output the results to a file named “kubelet-config.txt”.

<br>
<details><summary>Solution</summary>
<br>

```bash
# view the client certificate that kubelet uses to authenticate to the Kubernetes API
cat /etc/kubernetes/kubelet.conf > kubelet-config.txt

```{{exec}}

Optionally, you can decode the certificate. First, get the certificate file location from the 'kubelet.conf' file. Then, take out the new line characters.
```bash
# cat out the contents of '/var/lib/kubelet/pki/kubelet-client-current.pem' and take out the new line characters. Save it to a file named 'cert'
cat /var/lib/kubelet/pki/kubelet-client-current.pem | tr -d "\n" > cert
```{{exec}}

Use openssl to read the file, first taking out the `----BEGIN RSA PRIVATE KEY----` and everything after, including `----END RSA PRIVATE KEY-----`. The file should now look like this:
```bash
-----BEGIN CERTIFICATE-----
MIIDJzCCAg+gAwIBAgIIbwVUOF9oiIcwDQYJKoZIhvcNAQELBQAwFTETMBEGA1UEAxMKa3ViZXJuZXRlczAeFw0yNDAxMDUxMzQ0NTVaFw0yNTAxMDQxMzQ5NTZaMDoxFTATBgNVBAoTDHN5c3RlbTpub2RlczEhMB8GA1UEAxMYc3lzdGVtOm5vZGU6Y29udHJvbHBsYW5lMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAtCUtTLL5LtOUp0T8NxSeUycVJb3XhsFZqc0V2OcjWF0bL+Wwk3s6Mc6VY2uV+8PeM0AqQjebBG1vVnSIBkrX1cgv7wZ+E4uCueNnrcGAQNfwmTZytkosBimYNATIXzbu86Y81g6hYrR4PzJBGMdfwUp5nLHc8HGTOnKmGrpgbgogpo2XamzuE9ynlEDg8AkpomclMrxGaewmXsxGBpQmwevD2EvPihxLHPRa1BNWW6IHGFsXLhKfBgYZXEZe+WTMCHHntHwtLiUCyMAns5fj16GNmctdydYPZKkmz12oiU/1qrnNlyxCp+uaEryv+1O92rb7AhZxckDx0PbG2xv5VQIDAQABo1YwVDAOBgNVHQ8BAf8EBAMCBaAwEwYDVR0lBAwwCgYIKwYBBQUHAwIwDAYDVR0TAQH/BAIwADAfBgNVHSMEGDAWgBRJ7lQFLivnulXAvx7v8xy2Hen6bjANBgkqhkiG9w0BAQsFAAOCAQEASJhf9ZqdCz0FX7IXdt4q/bYC7DNtTWMQz35f6cNl9+mMskSXjsdbrDzJG7QVZNFPJ/I/zRr/qugrGODywVbVxBQXBCnb3loWWXLgMrvSsGFFd51Vl3c5upCo79WOpN+6EVqBlDBycUwbZsihgnATRFF3fW0580vScZlNL9rw9Jxp6OdNH9OPSgqIx+yhQnfdJbRggfUZ7i8NM7WIthfS1vyW7ttjITZUCtryynNUdiclcSBxuKcep2XtOP8ty4rzG+wxASVuLubrGOPwFEJXHZDAqJGfR1Ek/Ezc5y4Znv8MfEWFd+4zooWMUwrICWQqPhpbFjz+AmGYW+1gCoznCw==
-----END CERTIFICATE-----
```


</details>