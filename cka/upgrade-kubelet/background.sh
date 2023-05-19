echo "KUBELET_EXTRA_ARGS=\"--container-runtime-endpoint unix:///run/containerd/containerd.sock --cgroup-driver=systemd --eviction-hard imagefs.available<5%,memory.available<100Mi,nodefs.available<5%\"" > /etc/default/kubelet

mkdir -p /etc/apt/keyrings