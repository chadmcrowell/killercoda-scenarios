## Step 14: Check for data inconsistency

```bash
kubectl exec split-test-0 -- sh -c 'echo "Write from partition A" >> /tmp/data.txt'
kubectl exec split-test-1 -- sh -c 'echo "Write from partition B" >> /tmp/data.txt'

kubectl exec split-test-0 -- cat /tmp/data.txt
kubectl exec split-test-1 -- cat /tmp/data.txt
```{{exec}}

Writes in partitions can conflict or diverge when merged.
