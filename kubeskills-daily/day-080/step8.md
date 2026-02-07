## Step 8: Test cloud provider rate limits

```bash
echo "Cloud Provider Rate Limits:"
echo ""
echo "AWS EKS:"
echo "- DescribeCluster: 10 TPS"
echo "- ListClusters: 10 TPS"
echo "- CreateNodegroup: 2 TPS"
echo ""
echo "GCP GKE:"
echo "- Read requests: 1000 per 100 seconds"
echo "- Write requests: 100 per 100 seconds"
echo ""
echo "Azure AKS:"
echo "- Read: 500/min"
echo "- Write: 50/min"
echo ""
echo "Symptoms when hit:"
echo "- kubectl commands fail"
echo "- Cluster scaling delayed"
echo "- Controller reconciliation stuck"
```{{exec}}

Cloud providers impose their own rate limits on top of Kubernetes API limits - hitting these delays scaling and operations.
