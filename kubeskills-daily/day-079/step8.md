## Step 8: Test unsigned image

```bash
# Deploy without signature verification
echo "Docker Content Trust (DCT) disabled by default"
echo ""
echo "Without signature verification:"
echo "- Can't verify image publisher"
echo "- Can't detect man-in-the-middle attacks"
echo "- Can't ensure image integrity"
echo "- No guarantee image hasn't been tampered"
echo ""
echo "Enable with:"
echo "export DOCKER_CONTENT_TRUST=1"
```{{exec}}

Without image signing and verification, there is no way to confirm an image hasn't been tampered with.
