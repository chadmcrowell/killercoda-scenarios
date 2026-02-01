## Step 8: Test trace sampling issues

```bash
echo "Distributed tracing sampling:"
echo "- 100% sampling: Too much data"
echo "- 1% sampling: Miss rare errors"
echo "- Tail sampling: Requires more infrastructure"
echo ""
echo "Problems:"
echo "- Sampled out important traces"
echo "- Can't reproduce user issues"
echo "- Incomplete request path"
```{{exec}}

Trace sampling must balance coverage and volume.
