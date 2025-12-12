## Step 15: Monitor reconciliation performance

```bash
kubectl get webapp with-conditions -o jsonpath='{.metadata.resourceVersion}'
echo ""

kubectl get webapp with-conditions -o jsonpath='{.metadata.generation}'
echo ""

kubectl patch webapp with-conditions --type=merge -p '{"spec":{"message":"Updated"}}'

kubectl get webapp with-conditions -o jsonpath='{.metadata.generation}'
echo ""
```{{exec}}

Generation increments on spec changes; track to avoid redundant reconciles.
