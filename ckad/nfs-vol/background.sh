#/bin/bash

apt update && apt -y upgrade

apt install -y nfs-server

mkdir /data

cat << EOF >> /etc/exports
/data 172.30.2.2(rw,no_subtree_check,no_root_squash)
EOF

systemctl enable --now nfs-server

exportfs -ar