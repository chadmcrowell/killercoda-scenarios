## Step 12: Test metrics scrape interval

```bash
echo "Scrape interval impact:"
echo ""
echo "15s interval (default):"
echo "- 4 samples per minute"
echo "- Misses spikes < 15s"
echo "- Lower storage usage"
echo ""
echo "5s interval:"
echo "- 12 samples per minute"
echo "- Better resolution"
echo "- 3x storage usage"
echo "- Higher cardinality"
```{{exec}}

Scrape interval affects resolution and storage.
