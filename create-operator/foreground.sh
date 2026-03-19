# download kubebuilder and install locally.
curl -L -o kubebuilder https://go.kubebuilder.io/dl/latest/$(go env GOOS)/$(go env GOARCH)
chmod +x kubebuilder && mv kubebuilder /usr/local/bin/

# update go to the latest stable version
GOLATEST=$(curl -fsSL "https://go.dev/VERSION?m=text" | head -1)
wget "https://go.dev/dl/${GOLATEST}.linux-amd64.tar.gz"
rm -rf /usr/local/go && tar -C /usr/local -xzf "${GOLATEST}.linux-amd64.tar.gz"
rm "${GOLATEST}.linux-amd64.tar.gz"

# ensure go is on PATH for all future shells
echo 'export PATH=$PATH:/usr/local/go/bin' >> /root/.bashrc
export PATH=$PATH:/usr/local/go/bin
go version

go env -w GOTOOLCHAIN=local

# make working directory
mkdir -p ~/src
