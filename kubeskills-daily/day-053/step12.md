## Step 12: Test distributed consensus (conceptual)

```bash
echo "Raft consensus during partition:"
echo "- Majority partition can elect leader and accept writes"
echo "- Minority partition cannot elect leader and is read-only/unavailable"
echo "- Quorum prevents split-brain by requiring majority"
```{{exec}}

Consensus systems avoid split-brain by requiring quorum.
