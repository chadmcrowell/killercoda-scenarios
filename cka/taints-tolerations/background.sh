kubectl taint no node01 dedicated=special-user:NoSchedule

cat <<EOF > $HOME/pod.yaml
apiVersion: v1
kind: Pod
metadata:
  labels:
    run: nginx
  name: nginx
spec:
  containers:
  - image: nginx
    name: nginx
EOF