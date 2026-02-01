## Step 10: Test kubectl version skew

```bash
# kubectl should be within ±1 minor version of cluster
CLIENT_VERSION=$(kubectl version --client -o json | jq -r '.clientVersion.minor' | sed 's/[^0-9]//g')
SERVER_VERSION=$(kubectl version -o json | jq -r '.serverVersion.minor' | sed 's/[^0-9]//g')

echo "Client version: 1.$CLIENT_VERSION"
echo "Server version: 1.$SERVER_VERSION"

DIFF=$((CLIENT_VERSION - SERVER_VERSION))
if [ ${DIFF#-} -gt 1 ]; then
  echo "WARNING: Version skew too large (±1 supported)"
else
  echo "Version skew acceptable"
fi
```{{exec}}

kubectl must be within ±1 minor version of the cluster.
