wget https://raw.githubusercontent.com/chadmcrowell/acing-the-ckad-exam/main/ch_02/pod-nfs-vol.yaml

wget https://raw.githubusercontent.com/chadmcrowell/acing-the-ckad-exam/main/ch_02/nfs-server-install.sh

chmod +x ./nfs-server-install.sh

scp ./nfs-server-install.sh node01:~/