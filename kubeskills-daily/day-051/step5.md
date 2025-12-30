## Step 5: Create custom PriorityLevelConfiguration

```bash
cat <<'EOF' | kubectl apply -f -
apiVersion: flowcontrol.apiserver.k8s.io/v1beta3
kind: PriorityLevelConfiguration
metadata:
  name: test-priority
spec:
  type: Limited
  limited:
    nominalConcurrencyShares: 10
    limitResponse:
      type: Queue
      queuing:
        queues: 16
        queueLengthLimit: 50
        handSize: 4
EOF
```{{exec}}

Defines a limited priority with queuing parameters.
