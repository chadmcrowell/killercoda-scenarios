
Since Kubernetes doesn't have a "user" resource, all that's required is a client certificate and key with the common name (CN) to match the user's name.

In our case, when we created the **RoleBinding**, we assigned it to the user "carlton", so that user will assume the permissions from the **Role** for that resource.

As long as the CN in the key is "carlton", we will be able to use this to access the Kubernetes API.

To create a private key, we can use the **openssl** command-line tool. We'll use 2048 bit encryption and we'll name it carlton.key

`openssl genrsa -out carlton.key 2048`{{exec}}

Kubernetes itself is a certificate authority, therefore, it can approve and generate certificates. How convenient! 

Let's create a Certificate Signing Request (CSR) for the Kubernetes API using our private key and insert the common name and output that to a file named carlton.csr with the following command

`openssl req -new -key carlton.key -subj "/CN=carlton" -out carlton.csr`{{exec}}

> 🛑IMPORTANT🛑: Make sure to insert the Common Name (CN) into your CSR, or else the certificate will become invalid

Listing the contents of your current directory should look like this:
```bash
$ ls
carlton.csr  carlton.key  snap
```