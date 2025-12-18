[Quick Reference](https://kubernetes.io/docs/setup/production-environment/container-runtimes/#containerd)

Install containerd from the package here: [https://github.com/containerd/containerd/releases/latest](https://github.com/containerd/containerd/releases/latest) and extract it under `/usr/local`

```bash
# extract the binaries into /usr/local/bin, placing executables like containerd, ctr, containerd-shim-runc-v2, and containerd-stress in that location
sudo tar Cxzvf /usr/local https://github.com/containerd/containerd/releases/download/v2.2.0/containerd-2.2.0-linux-amd64.tar.gz

# create a symbolic link from /usr/local/bin/containerd to /usr/local/sbin/containerd
# This symlink ensures that containerd can be found in /usr/local/sbin, which is where some systemd service files or init systems might expect to find the containerd daemon binary.
sudo ln -sf /usr/local/bin/containerd /usr/local/sbin/containerd
```{{exec}}

Configure systemd units for containerd:

```bash
cat <<'EOF_UNIT' | sudo tee /etc/systemd/system/containerd.service
[Unit]
Description=containerd container runtime
Documentation=https://containerd.io
After=network.target

[Service]
ExecStart=/usr/local/bin/containerd
Restart=always
RestartSec=5
RuntimeDirectory=containerd
Delegate=yes
KillMode=process
OOMScoreAdjust=-999

[Install]
WantedBy=multi-user.target
EOF_UNIT
```{{exec}}

Reload systemd and start containerd:

```bash
sudo systemctl daemon-reload
sudo systemctl enable --now containerd
```{{exec}}

Verify the service:

```bash
sudo systemctl status containerd --no-pager
```{{exec}}

> Note: Ensure runc and CNI plugins are installed separately if not already present on the node.
