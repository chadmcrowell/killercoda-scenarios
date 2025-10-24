# download kubebuilder and install locally.
curl -L -o kubebuilder https://go.kubebuilder.io/dl/latest/$(go env GOOS)/$(go env GOARCH)
chmod +x kubebuilder && mv kubebuilder /usr/local/bin/

# update go to the version required by the project (and lock the toolchain locally)
wget https://go.dev/dl/go1.24.9.linux-amd64.tar.gz
rm -rf /usr/local/go && tar -C /usr/local -xzf go1.24.9.linux-amd64.tar.gz
go version
rm go1.24.9.linux-amd64.tar.gz

go env -w GOTOOLCHAIN=local

# make working directory
mkdir -p src
cd ./src
