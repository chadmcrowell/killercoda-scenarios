## Step 8: Test observedGeneration pattern

```bash
GENERATION=$(kubectl get webapp test-app -o jsonpath='{.metadata.generation}')
echo "Generation: $GENERATION"

kubectl patch webapp test-app --subresource=status --type=merge -p "{\"status\":{\"observedGeneration\":$GENERATION}}"
```{{exec}}

Operators skip work when observedGeneration already equals metadata.generation.
