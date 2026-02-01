## Step 2: Check for deprecated API usage

```bash
# List all API versions
kubectl api-versions | sort

# Check for beta APIs (often deprecated)
kubectl api-resources | grep -i beta
```{{exec}}

Identify deprecated API versions still available in the cluster.
