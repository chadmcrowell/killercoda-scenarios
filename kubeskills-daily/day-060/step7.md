## Step 7: Watch resource flapping

```bash
# Watch replicas value change constantly
watch -n 1 "kubectl get apptask test-apptask -o jsonpath='{.spec.replicas}'"

# Two controllers fighting over same field!
```{{exec}}

When controllers disagree, the spec flips back and forth.
