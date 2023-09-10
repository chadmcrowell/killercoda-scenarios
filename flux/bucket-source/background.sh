curl -s https://fluxcd.io/install.sh | sudo bash

wget https://raw.githubusercontent.com/chadmcrowell/flux-playground/main/bucket-source/bucket-policy.json

wget https://raw.githubusercontent.com/chadmcrowell/flux-playground/main/bucket-source/inline-policy.json

flux install


curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"

unzip awscliv2.zip

sudo ./aws/install