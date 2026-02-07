## Step 1: Demonstrate image tag mutability

```bash
# Pull image with 'latest' tag
kubectl run test-latest --image=nginx:latest

# Tag is mutable - can change without notice
echo "Problem with 'latest' tag:"
echo "- Points to different image over time"
echo "- No guarantee of what you're running"
echo "- Can't reproduce deployments"
echo "- Security patches change behavior"
```{{exec}}

The 'latest' tag is mutable and can point to a completely different image at any time.
