Let’s start with a quick warm-up.

```bash
whoami
hostname
sudo ls -1 /etc/kubernetes/pki
```

You should see files like:
`apiserver.crt`, `apiserver.key`, `ca.crt`, `ca.key`, `sa.pub`, `sa.key`

Peek inside the certificates
```bash
sudo openssl x509 -in /etc/kubernetes/pki/apiserver.crt -noout -text | egrep 'Subject:|Issuer:|DNS:|IP Address:'
sudo openssl x509 -in /etc/kubernetes/pki/ca.crt -noout -text | egrep 'Subject:|Issuer:'
```

See how kubectl uses them

```bash
sudo egrep -n 'certificate-authority|client-certificate|client-key' /etc/kubernetes/admin.conf
```

Observation:
`admin.conf` references the CA and a client cert/key from `/etc/kubernetes/pki`. This is how kubectl proves who you are to the API server.


---

